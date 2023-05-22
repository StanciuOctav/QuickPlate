//
//  TablesView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.03.2023.
//

import SwiftUI

struct TablesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = TablesViewViewModel()
    @State private var presentAlert: Bool = false
    @State private var confirmationAlert: Bool = false
    @State private var selectedTable = Table()
    @State private var selectedHour: Int = 0
    @State private var selectedDay: String = ""
    
    let restaurant: Restaurant
    let minHour: Int
    let maxHour: Int
    let weekdays: [String]
    
    var body: some View {
        VStack {
            if vm.tables.count == 0 {
                Text(LocalizedStringKey("no-available-tables"))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(Color.qpOrange)
                    .fontWeight(.heavy)
            } else {
                ScrollView {
                    ForEach(vm.tables) { table in
                        HStack {
                            VStack(spacing: 5) {
                                Text("\(table.nrPersons)")
                                HStack {
                                    ForEach(0 ..< table.nrPersons, id: \.self) { _ in
                                        Image(systemName: "person.fill")
                                    }
                                }
                            }
                            Spacer()
                            Button(LocalizedStringKey("book-table-action")) {
                                presentAlert.toggle()
                                selectedTable = table
                            }
                            .foregroundColor(Color.qpOrange)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                    }
                    .padding()
                }
                Spacer()
                HStack {
                    VStack {
                        Text(LocalizedStringKey("choose-hour"))
                        Picker("", selection: $selectedHour) {
                            ForEach(minHour ... maxHour, id: \.self) {
                                Text("\($0):00")
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .padding()
                    VStack {
                        Text(LocalizedStringKey("choose-day"))
                        Picker("", selection: $selectedDay) {
                            ForEach(self.weekdays, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(5)
                .padding()
            }
        }
        .background(Color.qpLightGrayColor)
        .alert(LocalizedStringKey("confirm"), isPresented: $presentAlert) {
            Button(LocalizedStringKey("yes"), role: .cancel) {
                vm.bookingTable(tableId: self.selectedTable.id ?? "", hour: String(self.selectedHour) + ":00", day: self.selectedDay, userId: UserDefaults.standard.string(forKey: "userId") ?? "")
                presentAlert.toggle()
                confirmationAlert.toggle()
                self.selectedHour = Int(self.restaurant.openHour.split(separator: ":")[0]) ?? 0
                self.selectedDay = weekdays[0]
                self.selectedDay = self.restaurant.openDays[0]
            }
            Button(LocalizedStringKey("no"), role: .destructive) {
                presentAlert.toggle()
            }
        }
        .alert(LocalizedStringKey("booking-confirmed"), isPresented: $confirmationAlert) {
            Button("Ok", role: .cancel) {
                confirmationAlert.toggle()
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedStringKey("cancel")) {
                    dismiss()
                }
                .foregroundColor(Color.qpOrange)
            }
            ToolbarItem(placement: .principal) {
                Text(LocalizedStringKey("book-table"))
                    .fontWeight(.bold)
                    .foregroundColor(Color.qpBlackColor)
            }
        }
        .task {
            await self.vm.fetchAllTables(forRestaurant: self.restaurant)
            self.selectedHour = Int(self.restaurant.openHour.split(separator: ":")[0]) ?? 0
            self.selectedDay = self.restaurant.openDays[0]
        }
    }
}
