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

                Text(restaurant.address)
                    .font(.subheadline)
                Text(restaurant.openHour + " - " + restaurant.closeHour)
                    .foregroundColor(.green)
                Text("Rating: " + String(format: "%.1f", restaurant.rating))
            }
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

//struct RestaurantCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantCardView(restaurant: RestaurantCardDTO)
//        // .previewLayout(.fixed(width: 400, height: 100))
//    }
//}
