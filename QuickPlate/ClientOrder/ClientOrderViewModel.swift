//
//  ClientOrderViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 20.03.2023.
//

import FirebaseFirestore
import Foundation

final class ClientOrderViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var numberOrdered: [Int] = []
    @Published var totalCost: Double = 0

    private var foodIds: [String] = []
    private var tableId: String = ""
    private var table = Table()

    func updateTableIdWith(id: String) {
        tableId = id
        FSTableColl.shared.getTableWith(id: tableId) { table in
            guard let table = table else {
                print("ClientOrderVM - Couldn't retrive table with id \(self.tableId)")
                return
            }
            self.table = table
        }
    }

    func fetchFoodIds() async {
        await FSResColl.shared.getResMenuThatHas(tableId: tableId, completion: { foodIds in
            guard let foodIds = foodIds else {
                print("ClientOrderViewModel - Couldn't get foods for restaurant")
                return
            }
            self.foodIds = foodIds
            for id in self.foodIds {
                FSFoodsColl.shared.fetchFoodWith(id: id) { food in
                    guard let food = food else { return }
                    self.foods.append(food)
                    self.numberOrdered.append(0)
                }
            }
            self.foodIds.removeAll()
            for f in self.foods {
                self.foodIds.append(f.id ?? "")
            }
        })
    }
    
    func sendOrder() {
        FSResColl.shared.getResNameThatHas(tableId: self.tableId) { name in
            guard let name = name else {
                print("ClientOrderVM - Couldn't get restaurant's name that has the table with id \(self.tableId)")
                return
            }
            var ids: [String] = []
            var quan: [Int] = []
            for (index, nr) in self.numberOrdered.enumerated() {
                if nr > 0 {
                    ids.append(self.foods[index].id ?? "")
                    quan.append(nr)
                    FSFoodsColl.shared.updateFoodstockkWith(id: self.foods[index].id ?? "", nrOrdered: nr)
                }
            }
            let order = Order(id: UUID().uuidString, resName: name, tableNr: self.table.tableNumber, foodIds: ids, foodQuantity: quan, totalCost: self.totalCost)
            FSOrdersColl.shared.saveOrder(order)
        }
    }

    func decrementFood(_ index: Int) {
        if numberOrdered[index] > 0 && numberOrdered[index] <= foods[index].stock {
            numberOrdered[index] -= 1
        }
        self.calculateTotalCost()
    }

    func incrementFood(_ index: Int) {
        if numberOrdered[index] >= 0 && numberOrdered[index] < foods[index].stock {
            numberOrdered[index] += 1
        }
        self.calculateTotalCost()
    }
    
    func didOrderFood() -> Bool {
        for nr in numberOrdered {
            if nr > 0 {
                return true
            }
        }
        return false
    }

    func resetOrder() {
        totalCost = 0
        numberOrdered = numberOrdered.map { _ in 0 }
    }
    
    private func calculateTotalCost() {
        totalCost = 0.0
        for (index, nr) in numberOrdered.enumerated() {
            totalCost += Double(nr) * self.foods[index].price
        }
    }
}
