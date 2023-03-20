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
    
    private var foodIds: [String] = []
    private var tableId: String = ""

    func updateTableIdWith(id: String) {
        tableId = id
    }

    func fetchFoodIds() async {
        await FSResColl.shared.getResMenuThatHas(tableId: tableId, completion: { foods in
            guard let foods = foods else {
                print("ClientOrderViewModel - Couldn't get foods for restaurant")
                return
            }
            self.foodIds = foods
            for id in self.foodIds {
                FSFoodsColl.shared.fetchFoodWith(id: id) { food in
                    guard let food = food else { return }
                    self.foods.append(food)
                    self.numberOrdered.append(0)
                }
            }
        })
    }
    
    func decrementFood(_ index: Int) {
        if numberOrdered[index] > 0 && numberOrdered[index] <= foods[index].stoc {
            numberOrdered[index] -= 1
        }
    }
    
    func incrementFood(_ index: Int) {
        if numberOrdered[index] >= 0 && numberOrdered[index] < foods[index].stoc {
            numberOrdered[index] += 1
        }
    }
}
