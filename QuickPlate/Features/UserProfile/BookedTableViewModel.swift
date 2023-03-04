//
//  BookedTableVM.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.03.2023.
//

import Foundation
import FirebaseFirestore
import SwiftUI

final class BookedTableViewModel: ObservableObject {
    @Published var restaurantName: String = ""
    
    private var restaurants = [Restaurant]()
    private let coll = Firestore.firestore().collection("Restaurants")

    func fetchRestaurantName(tableId: String) async {
        coll.getDocuments() { querySnapshot, error in
            if let error = error {
                print("BookedTableVM - Couldn't get restaurants")
                print(error.localizedDescription)
            }
            guard let documents = querySnapshot?.documents else {
                print("BookedTableVM - No documents!")
                return
            }
            self.restaurants = documents.map({ qdSnap in
                let defaultRes = Restaurant()
                var res = Restaurant()
                do {
                    res = try qdSnap.data(as: Restaurant.self)
                    self.addRestaurant(res: res)
                } catch {
                    print(error.localizedDescription)
                    return defaultRes
                }
                return res
            })
            for r in self.restaurants {
                print(r)
            }
            for r in self.restaurants {
                let _ = r.tables.contains(where: { s in
                    if (s == tableId) {
                        self.restaurantName = r.name
                        return true
                    }
                    return false
                })
            }
        }
    }
    
    private func addRestaurant(res: Restaurant) {
        self.restaurants.append(res)
    }
}
