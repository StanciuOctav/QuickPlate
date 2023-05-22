//
//  MapViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.01.2023.
//

import CoreLocation
import FirebaseFirestore
import Foundation
import SwiftUI

struct MyAnnotationItem: Identifiable {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var restaurantRating: Double
}

final class MapViewModel: ObservableObject {
    @Published var annotationItems: [MyAnnotationItem] = []
    private var restaurants: [RestaurantCardDTO] = []
    
    func fetchAllRestaurants() async {
        await FSResColl.shared.fetchAllRestaurants(completion: { restaurants in
            guard let restaurants = restaurants else { return }
            self.restaurants = restaurants.compactMap({ r in
                r.restaurantCardDTO
            })
            self.updateAnnotationItems()
        })
    }
    
    func returnSelectedRestaurantWith(id: String) -> RestaurantCardDTO? {
        if let restaurant = restaurants.first(where: { $0.id == id }) {
            return restaurant
        }
        return nil
    }
}

// MARK: EXTENSION for annotation items management

extension MapViewModel {
    private func updateAnnotationItems() {
        annotationItems.removeAll()
        
        for restaurant in restaurants {
            let id = restaurant.id
            let geoPointLocation = restaurant.location
            let rating = restaurant.rating
            // If the restaurant is NOT shown on the map, it will be added in annotation items
            annotationItems.append(
                MyAnnotationItem(id: id ?? "",
                                 coordinate: CLLocationCoordinate2D(latitude: geoPointLocation.latitude, longitude: geoPointLocation.longitude),
                                 restaurantRating: rating
                                )
            )
        }
    }
}
