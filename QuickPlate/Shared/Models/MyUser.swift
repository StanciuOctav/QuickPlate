//
//  User.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class MyUser: Codable, Identifiable {
    var id: String = UUID().uuidString
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var role: String = ""
    var restaurantWorking: String = ""
    var email: String = ""
    var password: String = ""
    var favouriteRestaurants: [String] = []

    init() {}

    init(id: String, username: String, firstName: String, lastName: String, role: String, restaurantWorking: String, email: String, password: String, favouriteRestaurants: [String]) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.restaurantWorking = restaurantWorking
        self.email = email
        self.password = password
        self.favouriteRestaurants = favouriteRestaurants
    }
}
