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
    private var defaultRestaurants: [Restaurant] = []

    private let coll = Firestore.firestore().collection(FSCollNames.restaurants.rawValue)

    func fetchAllRestaurants() async {
        await FSResColl.shared.fetchAllRestaurants() { results in
            guard let results = results else { return }
            self.restaurants = results
            self.initializeDefaultRestaurants()
        }
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
