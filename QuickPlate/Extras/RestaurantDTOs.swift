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

struct RestaurantSignUpDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
}

