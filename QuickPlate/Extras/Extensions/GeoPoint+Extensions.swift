//
//  GeoPoint+Extensions.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.01.2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}
