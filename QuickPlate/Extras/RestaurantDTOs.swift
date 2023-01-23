//
//  RestaurantCardDTO.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.01.2023.
//

import CoreLocation
import Firebase
import FirebaseFirestoreSwift
import Foundation

struct RestaurantCardDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var imageURL: String = ""
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var address: String = ""
    var openHour: String = ""
    var closeHour: String = ""
    var rating: Double = 0.0
    var isFavourite: Bool?
}

extension RestaurantCardDTO {
    init(from entity: Restaurant) {
        self.id = entity.id
        self.name = entity.name
        self.imageURL = entity.imageURL
        self.location = entity.location
        self.address = entity.address
        self.openHour = entity.openHour
        self.closeHour = entity.closeHour
        self.rating = entity.rating
    }
}

struct RestaurantSignUpDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
}
