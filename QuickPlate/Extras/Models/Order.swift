//
//  Order.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.03.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var resName: String = ""
    var tableId: String = ""
    var foodIds: [String] = []
    var totalCost: Double = 0.0
}
