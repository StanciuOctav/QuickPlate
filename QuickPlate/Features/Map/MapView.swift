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
    @StateObject private var locManager: LocationManager = LocationManager()
    @State private var tracking: MapUserTrackingMode = .follow

    @StateObject private var vm: MapViewModel = MapViewModel()
    @State private var selectedRestaurant: RestaurantCardDTO?

    private var buttonHeightAndWidth: CGFloat = 50

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                Map(coordinateRegion: $locManager.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: $tracking,
                    annotationItems: $vm.annotationItems) { item in
                        MapAnnotation(coordinate: item.wrappedValue.coordinate) {
                            Button {
                                selectedRestaurant = vm.returnSelectedRestaurantWith(id: item.id)
                            } label: {
                                ZStack(alignment: .center) {
                                    Image("restaurant-pin")
                                        .resizable()
                                    Text("\(String(format: "%.1f", item.restaurantRating.wrappedValue))")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .onTapGesture {
                        selectedRestaurant = nil
                    }

                HStack {
                    Button {
                    } label: {
                        Circle()
                            .padding()
                            .foregroundColor(.white)
                            .background(.white)
                            .cornerRadius(.infinity)
                            .frame(width: self.buttonHeightAndWidth, height: self.buttonHeightAndWidth)
                            .overlay(
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
                            .frame(width: self.buttonHeightAndWidth, height: self.buttonHeightAndWidth)
                            .overlay(
                                Image(systemName: "location.fill")
                                    .foregroundColor(.black)
                            )
                    }
                    .padding()
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                if let selectedRestaurant = self.selectedRestaurant {
                    RestaurantCardView(restaurant: selectedRestaurant)
                } else {
                    EmptyView()
                }
            }
            .padding()
        }
        .onAppear {
            self.vm.fetchAllRestaurants()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
