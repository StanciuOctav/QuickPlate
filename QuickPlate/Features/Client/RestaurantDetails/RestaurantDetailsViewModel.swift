//
//  RestaurantDetailsViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 01.03.2023.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class RestaurantDetailsViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    func fetchRestaurantMenu(_ foodIds: [String]) async {
        await FSFoodsColl.shared.fetchAllFoods { foods in
            guard let foods = foods else { return }
            self.foods = foods.compactMap({ food in
                return foodIds.contains(where: {$0 == food.id}) ? food : nil
            })
        }
    }
}
