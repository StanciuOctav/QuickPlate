//
//  Order.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.03.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

enum OrderState: String, Codable {
    case pending, preparing, ready, sent
}

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var resName: String = ""
    var tableNr: Int = 0
    var foodIds: [String] = []
    var foodQuantity: [Int] = []
    var totalCost: Double = 0.0
    var userId: String = ""
    var tableId: String = ""
    var orderState: OrderState = .pending
}
