//
//  LocationManager.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 27.11.2022.
//

import SwiftUI
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Setting the current region to Cluj-Napoca
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    @Published var locationManager = CLLocationManager()
    
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if self.lastLocation != newLocation {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: newLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
            self.lastLocation = newLocation
            locationManager.stopUpdatingLocation() // So the user can navigate on the map
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}