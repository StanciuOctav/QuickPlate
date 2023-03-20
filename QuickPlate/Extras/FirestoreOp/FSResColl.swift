//
//  FSResColl.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 06.03.2023.
//

import Foundation
import FirebaseFirestore

final class FSResColl {
    let coll = Firestore.firestore().collection(FSCollNames.restaurants.rawValue)
    static let shared = FSResColl()
    
    func fetchAllRestaurants(completion: @escaping ([Restaurant]?) -> Void) async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("FSResColl - Could't retrieve restaurants")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = querySnapshot?.documents else {
                print("FSResColl - No documents!")
                completion(nil)
                return
            }
            let restaurants = documents.compactMap { qdSnap -> Restaurant? in
               return try? qdSnap.data(as: Restaurant.self)
            }
            completion(restaurants)
        }
    }
    
    // FIXME: Fix warnings trying this https://stackoverflow.com/questions/59482689/storing-asynchronous-cloud-firestore-query-results-in-swift
    func getResNameThatHas(tableId: String, completion: @escaping (String?) -> Void) async {
        coll.getDocuments() { querySnapshot, error in
            if let error = error {
                print("BookedTableVM - Couldn't get restaurants")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = querySnapshot?.documents else {
                print("BookedTableVM - No documents!")
                completion(nil)
                return
            }
            let restaurants = documents.compactMap({ qdSnap in
                return try? qdSnap.data(as: Restaurant.self)
            })
            restaurants.forEach { restaurant in
                restaurant.tables.forEach { currTableId in
                    if tableId == currTableId {
                        completion(restaurant.name)
                    }
                }
            }
        }
    }
    
    func getResMenuThatHas(tableId: String, completion: @escaping ([String]?) -> Void) async {
        coll.getDocuments() { querySnapshot, error in
            if let error = error {
                print("BookedTableVM - Couldn't get restaurants")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = querySnapshot?.documents else {
                print("BookedTableVM - No documents!")
                completion(nil)
                return
            }
            let restaurants = documents.compactMap({ qdSnap in
                return try? qdSnap.data(as: Restaurant.self)
            })
            restaurants.forEach { restaurant in
                restaurant.tables.forEach { currTableId in
                    if tableId == currTableId {
                        completion(restaurant.menu)
                    }
                }
            }
        }
    }
    
    func getResWithId(resId: String, completion: @escaping (Restaurant?) -> Void) {
        coll.document(resId).getDocument() { qdSnap, error in
            if let error = error {
                print("FSUserColl - Couldn't assign booked table to user")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let qdSnap = qdSnap else {
                completion(nil)
                return
            }
            completion(try? qdSnap.data(as: Restaurant.self))
        }
    }
}
