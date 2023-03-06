//
//  BookedTableVM.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.03.2023.
//

import Foundation
import FirebaseFirestore
import SwiftUI

final class BookedTableViewModel: ObservableObject {
    @Published var restaurantName: String = ""
    
    private var restaurants = [Restaurant]()

    func fetchRestaurantName(tableId: String) async {
        await FSResColl.shared.getResNameThatHas(tableId: tableId, completion: { name in
            guard let name = name else { return }
            self.restaurantName = name
        })
    }
    
    private func addRestaurant(res: Restaurant) {
        self.restaurants.append(res)
    }
}
