//
//  MapView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import CoreLocationUI
import MapKit
import SwiftUI


struct MapView: View {
    
    @StateObject private var usrLocViewModel = UserLocationViewModel()
    
    private var buttonHeight: CGFloat = 50
    private var buttonWidth: CGFloat = 50
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $usrLocViewModel.region, showsUserLocation: true)
                .ignoresSafeArea(edges: .top)
                
            HStack {
                Button {
                    
                } label: {
                    Circle()
                        .padding()
                        .foregroundColor(.white)
                        .background(.white)
                        .cornerRadius(.infinity)
                        .frame(width: self.buttonWidth, height: self.buttonHeight)
                        .overlay (
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        )
                }
                .padding()
                
                Spacer()
                
                Button {
                    usrLocViewModel.requestAllowOnceLocationPermission()
                } label: {
                    Circle()
                        .padding()
                        .foregroundColor(.white)
                        .background(.white)
                        .cornerRadius(.infinity)
                        .frame(width: self.buttonWidth, height: self.buttonHeight)
                        .overlay (
                            Image(systemName: "location.fill")
                                .foregroundColor(.black)
                        )
                        
                    
                }
                .padding()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

final class UserLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
