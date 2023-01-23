//
//  RestaurantsViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 08.01.2023.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class RestaurantsViewViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private var defaultRestaurants: [Restaurant] = []
    
    private let coll = Firestore.firestore().collection("Restaurants")
    
    func fetchAllRestaurants() async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("RestaurantCollection - Could't retrieve restaurants")
                print(error.localizedDescription)
            }
            guard let documents = querySnapshot?.documents else {
                print("RestaurantCollection - No documents!")
                return
            }
            self.restaurants = documents.map({ qdSnap in
                let defaultRes = Restaurant()
                var res = Restaurant()
                do {
                    res = try qdSnap.data(as: Restaurant.self)
                } catch {
                    print(error.localizedDescription)
                    return defaultRes
                }
                return res
            })
            self.initializeDefaultRestaurants()
        }
    }
    
    private func initializeDefaultRestaurants() {
        for res in restaurants {
            self.defaultRestaurants.append(res)
        }
    }
    
    func resetRestaurants() {
        self.restaurants.removeAll()
        self.defaultRestaurants.forEach { res in
            self.restaurants.append(res)
        }
    }
}
