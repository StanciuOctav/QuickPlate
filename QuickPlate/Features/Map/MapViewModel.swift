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

    private let coll = Firestore.firestore().collection("Restaurants")

    func fetchAllRestaurants() async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error {
                print("RestaurantCollection - Could't retrieve restaurants")
                print(error.localizedDescription)
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("RestaurantCollection - No documents!")
                return
            }

            self.restaurants = documents.map({ qdSnap in
                let defaultRes = RestaurantCardDTO()
                guard let res = try? qdSnap.data(as: RestaurantCardDTO.self) else { return defaultRes }
                return res
            })
            self.updateAnnotationItems()
        }
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
        // Delete the annotation items that has the same id with a restaurant that is no longer saved in the database
        if !annotationItems.isEmpty {
            annotationItems.removeAll { mai in
                !restaurants.contains(where: { $0.id == mai.id })
            }
        }
        
        for restaurant in restaurants {
            let id = restaurant.id
            let geoPointLocation = restaurant.location
            let rating = restaurant.rating
            // If the restaurant is NOT shown on the map, it will be added in annotation items
            if !annotationItems.contains(where: { $0.id == id }) {
                annotationItems.append(
                    MyAnnotationItem(id: id ?? "",
                                     coordinate: CLLocationCoordinate2D(latitude: geoPointLocation.latitude, longitude: geoPointLocation.longitude),
                                     restaurantRating: rating
                    )
                )
            } else {
                self.updateRestaurantWith(id: id ?? "", rating: rating, geoPointLocation: geoPointLocation)
            }
        }
    }
    
    private func updateRestaurantWith(id: String, rating: Double, geoPointLocation: GeoPoint) {
        var rest = annotationItems.first(where: {$0.id == id})! // can force unwrapped thx to the previous if clause
        // Restaurant has been updated in the meantime
        if rest.restaurantRating != rating || !rest.coordinate.isEqualTo(geoPoint: geoPointLocation) {
            rest.restaurantRating = rating
            rest.coordinate = geoPointLocation.toCLLocationCoordinate2D()
            if let index = annotationItems.firstIndex(where: {$0.id == id}) {
                self.annotationItems[index] = rest
            }
        }
    }
}

