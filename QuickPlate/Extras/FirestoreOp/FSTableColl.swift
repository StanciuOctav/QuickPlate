//
//  TablesCollection.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 06.03.2023.
//

import Foundation
import FirebaseFirestore

final class FSTableColl {
    let coll = Firestore.firestore().collection(FSCollNames.tables.rawValue)
    static let shared = FSTableColl()
    
    func tableBooked(tableId: String, hour: String, day: String) {
        coll.document(tableId).setData(["booked": true,
                                        "hourBooked": hour,
                                        "day": day], merge: true)
        
    }
    
    func fetchAllTables(forRestaurant restaurant: Restaurant, completion: @escaping ([Table]?) -> Void) async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("TablesCollection - Could't retrieve tables")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let documents = querySnapshot?.documents else {
                print("TablesCollection - No documents!")
                completion(nil)
                return
            }
            let tables = documents.compactMap({ qdSnap -> Table? in
                guard let table = try? qdSnap.data(as: Table.self) else { return nil }
                return restaurant.tables.contains(where: {$0 == table.id && !table.booked}) ? table : nil
            })
            completion(tables)
        }
    }
    
    func getTableWith(id: String, completion: @escaping (Table?) -> Void) {
        coll.document(id).getDocument(as: Table.self) { result in
            switch result {
            case .success(let res):
                completion(res)
            case .failure(let error):
                print("FSTableColl: Couldn't get table with id \(id)")
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
