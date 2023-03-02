//
//  User.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct MyUser: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var role: String = ""
    var restaurantWorking: String = ""
    var email: String = ""
    var password: String = ""
    var favouriteRestaurants = [String]()
    var bookedTables = [String]()
}
