//
//  BillViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.04.2023.
//

import Combine
import SwiftUI

final class BillViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var numberOrdered: [Int] = []
    @Published var totalCost: Double = 0
    @Published var canPay: Bool = false
    @Published var selectedPaymentMethod: Bool = false
    
    private var orders = CurrentValueSubject<[Order], Never>([Order]())
    private var foodIds: [String] = []
    private var cancelables = [AnyCancellable]()
    
    func getOrders() async {
        await FSOrdersColl.shared.fetchAllOrdersForCurrentUser({ orders in
            guard let orders = orders else { return }
            self.orders.value = orders.compactMap({ order in
                order.userId == UserDefaults.standard.string(forKey: "userId") ? order : nil
            })
        })
        
        orders.sink { [unowned self] _ in
            self.getFoods()
        }.store(in: &cancelables)
    }
    
    private func getFoodIndex(_ foodId: String) -> Int {
        for index in 0..<foodIds.count {
            if foodIds[index] == foodId {
                return index
            }
        }
        return -1
    }
    
    private func getFoods() {
        for order in orders.value {
            for index in 0 ..< order.foodIds.count {
                if !foodIds.contains(where: { $0 == order.foodIds[index] }) {
                    foodIds.append(order.foodIds[index])
                    numberOrdered.append(order.foodQuantity[index])
                } else {
                    numberOrdered[getFoodIndex(order.foodIds[index])] += order.foodQuantity[index]
                }
            }
        }
        
        var index = 0
        for foodId in foodIds {
            FSFoodsColl.shared.fetchFoodWith(id: foodId) { [unowned self] food in
                guard let food = food else { return }
                self.foods.append(food)
                self.totalCost += self.foods[index].price * Double(self.numberOrdered[index])
                index += 1
            }
        }
    }
}
