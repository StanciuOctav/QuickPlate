//
//  RestaurantDetailsView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.01.2023.
//

import FirebaseFirestore
import SwiftUI

struct RestaurantDetailsView: View {
    let restaurant: Restaurant
    @State var isFavourite: Bool = false
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image
                    .resizable()
                    .ignoresSafeArea(edges: .top)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 4)
                    .scaledToFit()
                    .opacity(0.5)
            } placeholder: {
                ProgressView()
            }
            HStack {
                Text(restaurant.name)
                    .font(.title)
                Spacer()
                isFavourite ? Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
                : Image(systemName: "star")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
            }
            .padding()
            VStack(alignment: .leading) {
                Text(restaurant.address)
                    .font(.title2)
                Text(restaurant.openHour + " - " + restaurant.closeHour)
                    .foregroundColor(.green)
                    .font(.title2)
                Text("Rating: " + String(format: "%.1f", restaurant.rating))
                    .font(.title2)
            }
//            VStack(alignment: .leading) {
//                Text(restaurant.description)
//                    .font(.title2)
//                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
//            }
            
            Spacer()
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView(restaurant: Restaurant(id: "3LaipEo6CDKAjn5U4dFT",
                                                     address: "Piața Muzeului 2, Cluj-Napoca 400019",
                                                     closeHour: "23:00",
                                                     location: GeoPoint(latitude: 46.77152454761758, longitude: 23.587253522621697),
                                                     name: "Marty",
                                                     //description: "Lorem ipsum dolor sit amet consecteur adisciping elit set diam Lorem ipsum dolor sit amet.",
                                                     openDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                                                     openHour: "11:00",
                                                     imageURL: "https://lh5.googleusercontent.com/p/AF1QipPt-VVI8HrxYQPRPmy5NIgi3Si4CI4mBp7JtX8s=w408-h544-k-no",
                                                     rating: 3.9,
                                                     reviews: [],
                                                     tables: []))
    }
}
