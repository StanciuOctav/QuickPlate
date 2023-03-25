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
        order.foodIds.forEach { foodId in
            FSFoodsColl.shared.fetchFoodWith(id: foodId) { food in
                guard let food = food else {
                    print("OrderCardVM - Couldn't get food with id \(foodId)")
                    return
                }
                self.foods.append(food)
            }
        }
    }
}
