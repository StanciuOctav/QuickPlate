//
//  RestaurantDetailsViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 01.03.2023.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class RestaurantDetailsViewModel: ObservableObject {
    @Published var foods: [Food] = []

    private let coll = Firestore.firestore().collection("Foods")

    func fetchFoods(_ foodIds: [String]) async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("FoodsCollection - Could't retrieve foods")
                print(error.localizedDescription)
            }
            guard let documents = querySnapshot?.documents else {
                print("FoodsCollection - No documents!")
                return
            }
            self.foods = documents.map({ qdSnap in
                let defaultFood = Food()
                var res = Food()
                do {
                    res = try qdSnap.data(as: Food.self)
                } catch {
                    print(error.localizedDescription)
                    return defaultFood
                }
                return res
            })
        }
    }
}
