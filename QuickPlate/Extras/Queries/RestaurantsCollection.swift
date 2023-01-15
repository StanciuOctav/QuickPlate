////
////  RestaurantsCollection.swift
////  QuickPlate
////
////  Created by Ioan-Octavian Stanciu on 11.12.2022.
////
//
// import CoreLocation
// import FirebaseFirestore
// import Foundation
//
// final class RestaurantsViewModel: ObservableObject {
//
//    @Published var restaurants: [Restaurant] = []
//
//    private let coll = Firestore.firestore().collection("Restaurants")
//
//    init() {
//        fetchAllRestaurants()
//    }
//
//    func fetchAllRestaurants() {
//        coll.addSnapshotListener { querySnapshot, error in
//            if let _ = error {
//                print("RestaurantCollection - Could't retrieve restaurants")
//            }
//            guard let documents = querySnapshot?.documents else {
//                print("RestaurantCollection - No documents!")
//                return
//            }
//            self.restaurants = documents.map({ qdSnap in
//                let id = qdSnap.documentID
//                let data = qdSnap.data()
//                let address = data["address"] as? String ?? ""
//                let closeHour = data["closeHour"] as? String ?? ""
//                let location = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
//                let name = data["name"] as? String ?? ""
//                let openDays = data["openDays"] as? [String] ?? []
//                let openHour = data["openHour"] as? String ?? ""
//                let picture = data["picture"] as? String ?? ""
//                let rating = data["rating"] as? Double ?? -1.0
//                let reviews = data["reviews"] as? [String] ?? []
//                let tables = data["tables"] as? [String] ?? []
//                return Restaurant(id: id, address: address, closeHour: closeHour, location: location, name: name, openDays: openDays, openHour: openHour, picture: picture, rating: rating, reviews: reviews, tables: tables)
//            })
//        }
//    }
// }
