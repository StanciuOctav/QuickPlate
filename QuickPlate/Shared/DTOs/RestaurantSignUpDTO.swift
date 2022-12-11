//
//  Restaurant.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import CoreLocation
import Firebase
import FirebaseFirestoreSwift
import Foundation

class RestaurantSignUpDTO: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""

    init() {}

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
