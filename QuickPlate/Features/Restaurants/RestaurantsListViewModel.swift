//
//  RestaurantsViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 08.01.2023.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class RestaurantsListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var favouritesRes: [String] = []
    private var defaultRestaurants: [Restaurant] = []

    private let coll = Firestore.firestore().collection(FSCollNames.restaurants.rawValue)

    func fetchAllRestaurants() async {
        await FSResColl.shared.fetchAllRestaurants() { results in
            guard let results = results else { return }
            self.restaurants = results
            self.initializeDefaultRestaurants()
        }
        await FSUserColl.shared.fetchFavouriteRestaurants(completion: { results in
            guard let results = results else { return }
            for restaurantId in results {
                if !self.favouritesRes.contains(where: {$0 == restaurantId}) {
                    self.favouritesRes.append(restaurantId)
                }
            }
        })
    }
    
    func addFavouriteRestaurant(restaurantId: String) {
        FSUserColl.shared.addRestaurantToFavourites(id: restaurantId)
    }
    
    func removeRestFromFavs(resId: String) {
        FSUserColl.shared.removeRestFromFavs(resId: resId)
        self.favouritesRes.removeAll(where: {$0 == resId})
    }

    private func initializeDefaultRestaurants() {
        for res in restaurants {
            defaultRestaurants.append(res)
        }
    }

    func resetRestaurants() {
        restaurants.removeAll()
        defaultRestaurants.forEach { res in
            self.restaurants.append(res)
        }
    }
}
