//
//  Table.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.03.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Table: Codable, Identifiable {
    @DocumentID var id: String?
    var booked: Bool = false
    var hourBooked: String = ""
    var nrPersons: Int = 0
    var tableNumber: Int = 0
    var day: String = ""
}

extension Table: Comparable {
    static func <(lhs: Table, rhs: Table) -> Bool {
        return lhs.id! < rhs.id!
       }
}
