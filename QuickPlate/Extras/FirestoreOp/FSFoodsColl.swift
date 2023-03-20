//
//  FSFoodsColl.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 06.03.2023.
//

import Foundation
import FirebaseFirestore

final class FSFoodsColl {
    private let coll = Firestore.firestore().collection(FSCollNames.foods.rawValue)
    static let shared = FSFoodsColl()
    
    func fetchAllFoods(completion: @escaping ([Food]?) -> Void) async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("FSFoodsColl - Could't retrieve foods")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = querySnapshot?.documents else {
                print("FSFoodsColl - No documents!")
                completion(nil)
                return
            }
            let foods = documents.compactMap { qdSnap -> Food? in
                return try? qdSnap.data(as: Food.self)
            }
            completion(foods)
        }
    }
    
    func fetchFoodWith(id: String, completion: @escaping (Food?) -> Void) {
        coll.document(id).getDocument { qdSnap, error in
            if let error = error {
                print("FSFoodsColl - Could't retrieve logged user")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let qdSnap = qdSnap else {
                print("FSFoodsColl - There is no user with the id \(id)")
                completion(nil)
                return
            }
            completion(try? qdSnap.data(as: Food.self))
        }
    }
}
