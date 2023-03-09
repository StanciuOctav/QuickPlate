//
//  Restaurant.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Restaurant: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var address: String = ""
    var closeHour: String = ""
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var name: String = ""
    var openDays = [String]()
    var openHour: String = ""
    var imageURL: String = ""
    var rating: Double = 0.0
    var reviews = [String]()
    var tables = [String]()
    var menu = [String]()
    var minHour: Int {
        get {
            Int(openHour.split(separator: ":")[0]) ?? 0
        }
    }
    var maxHour: Int {
        get {
            Int(closeHour.split(separator: ":")[0]) ?? 23
        }
    }
}

struct RestaurantCardDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var imageURL: String = ""
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var address: String = ""
    var openHour: String = ""
    var closeHour: String = ""
    var rating: Double = 0.0
}

struct RestaurantSignUpDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
}

extension Restaurant {
    var restaurantCardDTO: RestaurantCardDTO {
        RestaurantCardDTO(id: id, name: name, imageURL: imageURL, location: location, address: address, openHour: openHour, closeHour: closeHour, rating: rating)
    }
    var restaurantSignUpDTO: RestaurantSignUpDTO {
        RestaurantSignUpDTO(id: id, name: name)
    }
}
