//
//  RestaurantDetailsView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.01.2023.
//

import SwiftUI
import FirebaseFirestore

struct RestaurantDetailsView: View {
    let restaurant: Restaurant
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView(restaurant: Restaurant(id: "3LaipEo6CDKAjn5U4dFT",
                                                     address: "Piața Muzeului 2, Cluj-Napoca 400019",
                                                     closeHour: "23:00",
                                                     location: GeoPoint(latitude: 46.77152454761758, longitude: 23.587253522621697),
                                                     name: "Marty",
                                                     openDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                                                     openHour: "11:00",
                                                     imageURL: "https://lh5.googleusercontent.com/p/AF1QipPt-VVI8HrxYQPRPmy5NIgi3Si4CI4mBp7JtX8s=w408-h544-k-no",
                                                     rating: 3.9,
                                                     reviews: [],
                                                     tables: []))
    }
}
