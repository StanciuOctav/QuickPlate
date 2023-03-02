//
//  TablesViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.03.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore

final class TablesViewViewModel: ObservableObject {
    @Published var tables = [Table]()
    
    private let coll = Firestore.firestore().collection("Tables")
    private let usrColl = Firestore.firestore().collection("Users")
    
    func fetAllTables(forRestaurant restaurant: Restaurant) async {
        coll.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("TablesCollection - Could't retrieve tables")
                print(error.localizedDescription)
            }
            guard let documents = querySnapshot?.documents else {
                print("TablesCollection - No documents!")
                return
            }
            self.tables = documents.compactMap({ qdSnap in
                let defaultTable = Table()
                var res = Table()
                do {
                    res = try qdSnap.data(as: Table.self)
                } catch {
                    print(error.localizedDescription)
                    return defaultTable
                }
                return restaurant.tables.contains(where: {$0 == res.id && !res.booked}) ? res : nil
            })
        }
    }
    
    func bookingTable(tableId: String, hour: String, day: String) {
        coll.document(tableId).setData(["booked": true,
                                        "hourBooked": hour,
                                        "day": day], merge: true)
        updateTables()
    }
    
    private func updateTables() {
        self.tables.removeAll(where: {$0.booked})
    }
}
