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
    
    @StateObject private var locManager = LocationManager()
    @State var tracking: MapUserTrackingMode = .follow
    
    private var buttonHeight: CGFloat = 50
    private var buttonWidth: CGFloat = 50
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $locManager.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking)
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
                    locManager.locationManager.startUpdatingLocation()
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
