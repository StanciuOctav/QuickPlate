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
    @State private var tracking: MapUserTrackingMode = .follow
    
    @StateObject private var vm = MapViewModel()
    
    private var buttonHeightAndWidth: CGFloat = 50
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $locManager.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: $vm.annotationItems) { item in
                MapAnnotation(coordinate: item.wrappedValue.coordinate) {
                    Button {
                        print("Clicked on restaurant with id \(item.id)")
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
//        .onAppear {
//            vm.restaurants.forEach { restaurant in
//                print(restaurant.location)
//                annotationItems.append(
//    //                MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: res.location.latitude, longitude: res.location.longitude),
//    //                                 id: String(res.id))
//                    MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: restaurant.location.latitude,
//                                                                        longitude: restaurant.location.longitude))
//                )
//            }
//            print(annotationItems.count)
//        }
    }
}

// struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
// }
