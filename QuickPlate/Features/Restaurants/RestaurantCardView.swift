//
//  RestaurantCardView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 07.01.2023.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: RestaurantCardDTO

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image.resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
            } placeholder: {
                ProgressView()
            }
            .ignoresSafeArea(.all, edges: [.top, .bottom])

            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .fontWeight(.bold)
                Spacer()
                Text(restaurant.address)
                    .font(.caption)
                Text(restaurant.openHour + " - " + restaurant.closeHour)
                    .foregroundColor(.green)
                    .font(.caption)
                Text("Rating: " + String(format: "%.1f", restaurant.rating))
                    .font(.caption)
            }
            .padding(.vertical, 5)
            Spacer()
            VStack {
                if restaurant.isFavourite ?? false {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
                }
                Spacer()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: Color.qpBlackColor, radius: 2)
        )
        .frame(maxWidth: .infinity, maxHeight: 100)
    }
}
