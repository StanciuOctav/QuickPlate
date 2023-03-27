//
//  BookedTableView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.03.2023.
//

import SwiftUI

struct BookedTableView: View {
    @StateObject private var vm = BookedTableViewModel()
    let table: Table
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.restaurantName)
                    .font(.title2)
                HStack() {
                    Image(systemName: "person")
                        .resizable()
                        .fixedSize()
                    Text(": \(table.nrPersons)")
                }
                HStack() {
                    Image(systemName: "clock")
                        .resizable()
                        .fixedSize()
                    Text(": \(table.hourBooked)")
                }
                HStack() {
                    Image(systemName: "calendar")
                        .resizable()
                        .fixedSize()
                    Text(": \(table.day)")
                }
            }
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .task {
            await vm.fetchRestaurantName(tableId: self.table.id ?? "")
        }
    }
}
