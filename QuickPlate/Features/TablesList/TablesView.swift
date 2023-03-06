//
//  TablesView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.03.2023.
//

import SwiftUI

struct TablesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = TablesViewViewModel()
    @State private var presentAlert: Bool = false
    @State private var confirmationAlert: Bool = false
    @State private var selectedTable = Table()
    @State private var selectedHour: Int = 0
    @State private var selectedDay: String = ""
    @Binding var isPresentingBookedTables: Bool

    let restaurant: Restaurant
    let minHour: Int
    let maxHour: Int
    let weekdays: [String]

    var body: some View {
        VStack {
            if vm.tables.count == 0 {
                Text("We're sorry but all tables are booked at the moment 😢")
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
                            Button("Book") {
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
                        Text("Please choose an hour")
                        Picker("", selection: $selectedHour) {
                            ForEach(minHour ... maxHour, id: \.self) {
                                Text("\($0):00")
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .padding()
                    VStack {
                        Text("Please choose a day")
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
        .alert("Confirm?", isPresented: $presentAlert) {
            Button("Yes", role: .cancel) {
                vm.bookingTable(tableId: self.selectedTable.id ?? "", hour: String(self.selectedHour) + ":00", day: self.selectedDay)
                presentAlert.toggle()
                confirmationAlert.toggle()
                self.selectedHour = Int(self.restaurant.openHour.split(separator: ":")[0]) ?? 0
                self.selectedDay = weekdays[0]
            }
            Button("No", role: .destructive) {
                presentAlert.toggle()
            }
        }
        .alert(isPresented: $confirmationAlert) {
            Alert(title: Text("Booking confirmed!"), dismissButton: .cancel {
                confirmationAlert.toggle()
                self.isPresentingBookedTables = false
            })
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Color.qpOrange)
            }
            ToolbarItem(placement: .principal) {
                Text("Book a table")
                    .fontWeight(.bold)
                    .foregroundColor(Color.qpBlackColor)
            }
        }
        .task {
            await self.vm.fetchAllTables(forRestaurant: self.restaurant)
            self.selectedHour = Int(self.restaurant.openHour.split(separator: ":")[0]) ?? 0
        }
    }
}
