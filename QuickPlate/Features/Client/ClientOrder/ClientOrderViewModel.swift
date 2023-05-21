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
    @Published var hasUnfinishedOrders: Bool = false
    @Published var canPay: Bool = false

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

    func deleteBooking() {
        FSTableColl.shared.deleteBookingAtTable(tableId: tableId)
        FSUserColl.shared.deleteBookedTableWith(tableId: tableId) { res in
            guard let _ = res else {
                print("ClientOrderVM - Error in deleting table with id \(self.tableId)")
                return
            }
        }
        FSOrdersColl.shared.deleteOrdersAtTable(id: tableId)
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
        FSResColl.shared.getResNameThatHas(tableId: tableId) { name in
            guard let name = name else {
                print("ClientOrderVM - Couldn't get restaurant's name that has the table with id \(self.tableId)")
                return
            }
            var ids: [String] = []
            var quan: [Int] = []
            for index in 0 ..< self.numberOrdered.count {
                if self.numberOrdered[index] > 0 {
                    ids.append(self.foods[index].id ?? "")
                    quan.append(self.numberOrdered[index])
                    FSFoodsColl.shared.updateFoodstockkWith(id: self.foods[index].id ?? "", nrOrdered: self.numberOrdered[index], addStock: false)
                }
            }
            self.calculateTotalCost()
            let order = Order(id: UUID().uuidString,
                              resName: name,
                              tableNr: self.table.tableNumber,
                              foodIds: ids,
                              foodQuantity: quan,
                              totalCost: self.totalCost,
                              userId: UserDefaults.standard.value(forKey: "userId") as? String ?? "",
                              tableId: self.tableId,
                              orderState: .pending)
            FSOrdersColl.shared.saveOrder(order)
            self.resetOrder()
        }
    }

    // This method checks if the client still has orders that are not in the final state when he requests the bill
    func checkForOrdersStatus() {
        FSOrdersColl.shared.hasUnfinishedOrders(tableId: tableId) { [weak self] result in
            guard let result = result, let self = self else {
                print("ClientOrderViewModel - Couldn't check for order status")
                return
            }
            self.hasUnfinishedOrders = result
            self.canPay = !result
        }
    }

    func decrementFood(_ index: Int) {
        if numberOrdered[index] > 0 && numberOrdered[index] <= foods[index].stock {
            numberOrdered[index] -= 1
        }
        calculateTotalCost()
    }

    func incrementFood(_ index: Int) {
        if numberOrdered[index] >= 0 && numberOrdered[index] < foods[index].stock {
            numberOrdered[index] += 1
        }
        calculateTotalCost()
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
            totalCost += Double(nr) * foods[index].price
        }
    }
}
