//
//  CLLocationCoordinate2D+Extension.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.01.2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

// MARK: Codable
extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

// MARK: Equality
extension CLLocationCoordinate2D {
    func isEqualTo(geoPoint: GeoPoint) -> Bool {
        return self.latitude == geoPoint.latitude && self.longitude == geoPoint.longitude
    }
}
