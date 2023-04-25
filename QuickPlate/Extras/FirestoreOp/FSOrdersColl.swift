//
//  FSOrdersColl.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.03.2023.
//

import Foundation
import FirebaseFirestore

final class FSOrdersColl {
    let coll = Firestore.firestore().collection(FSCollNames.orders.rawValue)
    static let shared = FSOrdersColl()
    
    func saveOrder(_ order: Order) {
        do {
            try coll.document(order.id ?? UUID().uuidString).setData(from: order)
        } catch {
            print("FSOrderColl - Couldn't save order: \(order)")
            print(error.localizedDescription)
        }
    }
    
    func changeOrderState(id: String) {
        coll.document(id).getDocument { qdSnap, error in
            if let error = error {
                print("FSOrderColl - Couldn't retrieve order with id \(id)")
                print(error.localizedDescription)
            }
            guard let qdSnap = qdSnap else {
                print("FSOrderColl - There is no order with the id \(id)")
                return
            }
            let order = try? qdSnap.data(as: Order.self)
            guard let order = order else {
                print("FSOrderColl - Couldn't not convert qdSnap to order")
                return
            }
            switch order.orderState {
            case .pending:
                self.setOrderState(orderId: id, state: .preparing)
            case .preparing:
                self.setOrderState(orderId: id, state: .ready)
            case .ready:
                self.setOrderState(orderId: id, state: .sent)
            case .sent:
                break
            }
        }
    }
    
    private func setOrderState(orderId: String, state: OrderState) {
        coll.document(orderId).setData(["orderState": state.rawValue], merge: true)
    }
    
    func fetchOrdersForRestaurant(restaurantName: String, completion: @escaping ([Order]?) -> Void) {
        coll.addSnapshotListener { qdSnap, error in
            if let error = error {
                print("FSOrderColl - Couldn't get all orders")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = qdSnap?.documents else {
                print("FSOrderColl - Couldn't get documents")
                completion(nil)
                return
            }
            let orders = documents.compactMap { qdSnap -> Order? in
                let order = try? qdSnap.data(as: Order.self)
                return order?.resName == restaurantName ? order : nil
            }
            completion(orders)
        }
    }
    
    func deleteOrderWith(id: String) {
        coll.document(id).delete() { error in
            if let error = error {
                print("Couldn't delete order with id \(id)")
                print(error.localizedDescription)
            } else {
                print("Order with id \(id) was deleted")
            }
        }
    }
    
    func deleteOrdersAtTable(id: String) {
        print("Table Id: \(id)")
        coll.getDocuments { qdSnap, error in
            if let error = error {
                print("FSOrdersColl - Couldn't get orders")
                print(error.localizedDescription)
                return
            }
            guard let documents = qdSnap?.documents else {
                print("FSOrdersColl - Couldn't get orders 2")
                return
            }
            let orders = documents.compactMap { qdSnap -> Order? in
                return try? qdSnap.data(as: Order.self)
            }
            for index in 0..<orders.count {
                if orders[index].tableId == id {
                    self.deleteOrderWith(id: orders[index].id ?? "")
                }
            }
        }
    }
}
