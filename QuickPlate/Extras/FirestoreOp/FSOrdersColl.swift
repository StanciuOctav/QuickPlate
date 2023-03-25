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
    
    func fetchOrdersForRestaurant(restaurantName: String) {
        
    }
}
