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

struct Restaurant: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var address: String = ""
    var closeHour: String = ""
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var name: String = ""
    var openDays: [String] = []
    var openHour: String = ""
    var imageURL: String = ""
    var rating: Double = 0.0
    var reviews: [String] = []
    var tables: [String] = []
    var menu: [String] = []
}
