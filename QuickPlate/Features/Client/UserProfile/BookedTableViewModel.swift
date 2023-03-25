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

    func fetchRestaurantName(tableId: String) async {
        await FSResColl.shared.asyncGetResNameThatHas(tableId: tableId, completion: { name in
            guard let name = name else { return }
            self.restaurantName = name
        })
    }
}
