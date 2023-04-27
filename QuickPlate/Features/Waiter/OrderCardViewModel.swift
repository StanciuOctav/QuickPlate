//
//  OrderCardViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import Foundation

final class OrderCardViewModel: ObservableObject {
    @Published var foods = [Food]()

    func fetchFoodsFor(order: Order) {
        foods.removeAll()
        order.foodIds.forEach { foodId in
            // since accesing something from firestore is async, the order of the self.foods array won't be the same with order.foodIds
            FSFoodsColl.shared.fetchFoodWith(id: foodId) { food in
                guard let food = food else {
                    print("OrderCardVM - Couldn't get food with id \(foodId)")
                    return
                }
                self.foods.append(food)
                self.orderFoodsAfterIds(order)
            }
        }
    }

    private func orderFoodsAfterIds(_ order: Order) {
        for i in 0 ..< foods.count {
            if foods[i].id != order.foodIds[i] {
                for j in i + 1 ..< foods.count {
                    if foods[j].id == order.foodIds[i] {
                        foods.swapAt(i, j)
                        break
                    }
                }
            }
        }
    }
}
