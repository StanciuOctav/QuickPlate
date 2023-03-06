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
    
    func fetchAllTables(forRestaurant restaurant: Restaurant) async {
        await FSTableColl.shared.fetchAllTables(forRestaurant: restaurant, completion: { tables in
            guard let tables = tables else { return }
            self.tables = tables
        })
    }
    
    func bookingTable(tableId: String, hour: String, day: String) {
        FSTableColl.shared.tableBooked(tableId: tableId, hour: hour, day: day)
        FSUserColl.shared.saveBookedTable(withId: tableId)
        updateTables()
    }
    
    private func updateTables() {
        self.tables.removeAll(where: {$0.booked})
    }
}
