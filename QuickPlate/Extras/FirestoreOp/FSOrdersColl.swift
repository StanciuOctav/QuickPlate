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
}
