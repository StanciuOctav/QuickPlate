//
//  User.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct MyUser: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var role: String?
    var restaurantWorking: String?
    var email: String?
    var password: String?
    var favouriteRestaurants: [String]?
    
    init?(username: String? = nil, firstName: String? = nil, lastName: String? = nil, role: String? = nil, restaurantWorking: String, email: String? = nil, password: String? = nil, favouriteRestaurants: [String]) {
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
