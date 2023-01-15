//
//  Restaurant.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

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

extension RestaurantSignUpDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RestaurantSignUpDTO, rhs: RestaurantSignUpDTO) -> Bool {
        return lhs.id == rhs.id
    }
}
