//
//  RestaurantsCollection.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import CoreLocation
import FirebaseFirestore
import Foundation

final class RestaurantsSignUpViewModel: ObservableObject {
    @Published var restaurants: [RestaurantSignUpDTO] = []

    private let coll = Firestore.firestore().collection("Restaurants")

    init() {
        fetchAllRestaurants()
    }

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
                return RestaurantSignUpDTO(id: id, name: name)
            })
        }
    }
}
