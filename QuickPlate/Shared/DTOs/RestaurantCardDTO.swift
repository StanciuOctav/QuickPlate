//
//  RestaurantCardDTO.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.01.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation
import CoreLocation

class RestaurantCardDTO: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var address: String = ""
    var openHour: String = ""
    var closeHour: String = ""
    var rating: Double = 0.0

    init() {}
    
    init(id: String = UUID().uuidString, name: String = "", location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0), address: String = "", openHour: String = "", closeHour: String = "", rating: Double = 0.0) {
        self.id = id
        self.name = name
        self.location = location
        self.address = address
        self.openHour = openHour
        self.closeHour = closeHour
        self.rating = rating
    }
}

extension RestaurantCardDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RestaurantCardDTO, rhs: RestaurantCardDTO) -> Bool {
        return lhs.id == rhs.id
    }
}
