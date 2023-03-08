//
//  RestaurantDetailsView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.01.2023.
//

import FirebaseFirestore
import SwiftUI

struct FoodCard: View {
    let food: Food

    var body: some View {
        VStack(alignment: .leading) {
            Text(food.foodName)
                .font(.title2)
                .bold()
            Text("Ingredients: " + food.ingredientsString)
            Text("Price: " + String(food.price))
        }
        .background(Color.qpLightGrayColor)
    }
}

struct RestaurantDetailsView: View {
    @StateObject var vm = RestaurantDetailsViewModel()
    @State var isFavourite: Bool = false
    @State var isPresentingTables: Bool = false
    let restaurant: Restaurant
    @State var value: Int = 0

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 4)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                HStack {
                    Text(restaurant.name)
                        .font(.title)
                        .bold()
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
                    Text("Meniu")
                        .font(.title)
                        .bold()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    ForEach(self.vm.foods) { food in
                        FoodCard(food: food)
                            .ignoresSafeArea(.all, edges: [.leading, .trailing])
                    }
                }

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .task {
                await self.vm.fetchRestaurantMenu(restaurant.menu)
            }
            .toolbar {
                Button {
                    self.isPresentingTables.toggle()
                } label: {
                    Text("Book a table")
                }
            }
            .sheet(isPresented: $isPresentingTables) {
                //NavigationView {
                    TablesView(restaurant: self.restaurant,
                               minHour: self.restaurant.minHour,
                               maxHour: self.restaurant.maxHour,
                               weekdays: self.restaurant.openDays
                )
                // }
            }
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
                                                     // description: "Lorem ipsum dolor sit amet consecteur adisciping elit set diam Lorem ipsum dolor sit amet.",
                                                     openDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                                                     openHour: "11:00",
                                                     imageURL: "https://lh5.googleusercontent.com/p/AF1QipPt-VVI8HrxYQPRPmy5NIgi3Si4CI4mBp7JtX8s=w408-h544-k-no",
                                                     rating: 3.9,
                                                     reviews: [],
                                                     tables: []))
    }
}
