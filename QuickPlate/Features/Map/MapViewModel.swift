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
    var coordinate: CLLocationCoordinate2D
    var restaurantRating: Double
    var id: String
}

final class MapViewModel: ObservableObject {
    @Published var restaurants: [RestaurantCardDTO] = []
    @Published var annotationItems: [MyAnnotationItem] = []

    private let coll = Firestore.firestore().collection("Restaurants")

    func fetchAllRestaurants() {
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
                let id = qdSnap.documentID
                let data = qdSnap.data()
                let name = data["name"] as? String ?? ""
                let picture = data["picture"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                let openHour = data["openHour"] as? String ?? ""
                let closeHour = data["closeHour"] as? String ?? ""
                let rating = data["rating"] as? Double ?? -1.0
                let location = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
                let res = RestaurantCardDTO(id: id, name: name, picture: picture, location: location, address: address, openHour: openHour, closeHour: closeHour, rating: rating)
                return res
            })
            self.addAnnotationItems()
        }
    }

    func addAnnotationItems() {
        for res in restaurants {
            let id = res.id
            let location = res.location
            let rating = res.rating
            annotationItems.append(
                MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                                 restaurantRating: rating,
                                 id: id)
            )
        }
    }
    
    func returnSelectedRestaurantWith(id: String) -> RestaurantCardDTO? {
        if let restaurant = self.restaurants.first(where: {$0.id == id}) {
            return restaurant
        } else {
            return nil
        }
    }
}
