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
                AsyncImage(url: URL(string: restaurant.picture)) { image in
                    image.resizable()
                        .cornerRadius(5)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text(restaurant.name)
                            .fontWeight(.bold)
                        Spacer()
                        if (restaurant.isFavourite) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                        
                    }
                    Text(restaurant.address)
                        .font(.subheadline)
                    Text(restaurant.openHour + " - " + restaurant.closeHour)
                        .foregroundColor(.green)
                    Text("Rating: " + String(format: "%.1f", restaurant.rating))
                }
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.white)
                    .shadow(color: Color.qpBlackColor, radius: 2)
            )
        .frame(maxWidth: .infinity)
    }
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCardView(restaurant: RestaurantCardDTO(id: "312", name: "Marty", picture: "https://lh5.googleusercontent.com/p/AF1QipPt-VVI8HrxYQPRPmy5NIgi3Si4CI4mBp7JtX8s=w408-h544-k-no", address: "Piața Muzeului 2, Cluj-Napoca 400019",openHour: "11:00", closeHour: "23:00", rating: 4.9))
            //.previewLayout(.fixed(width: 400, height: 100))
    }
}
