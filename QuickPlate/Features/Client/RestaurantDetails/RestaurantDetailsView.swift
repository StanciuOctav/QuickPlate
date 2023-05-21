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
            Text(LocalizedStringKey("ingredients").stringValue() + ": " + food.ingredientsString)
            Text(LocalizedStringKey("price").stringValue() + ": " +  String(food.price))
        }
        .background(Color.qpLightGrayColor)
    }
}

struct RestaurantDetailsView: View {
    @StateObject private var vm = RestaurantDetailsViewModel()
    @State private var isFavourite: Bool = false
    @State private var isPresentingTables: Bool = false
    let restaurant: Restaurant
    
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
                    
                    self.isOpened()
                    
                    Text(LocalizedStringKey("rating").stringValue() + String(format: " %.1f", restaurant.rating))
                        .font(.title2)
                    Text(LocalizedStringKey("menu"))
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
                    Text(LocalizedStringKey("book-table"))
                }
            }
            .sheet(isPresented: $isPresentingTables) {
                NavigationView {
                    TablesView(restaurant: self.restaurant,
                               minHour: self.restaurant.minHour,
                               maxHour: self.restaurant.maxHour,
                               weekdays: self.restaurant.openDays
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func isOpened() -> some View {
        let openHour = Int(restaurant.openHour.split(separator: ":").first!)!
        let closeHour = Int(restaurant.closeHour.split(separator: ":").first!)!
        let currentHour = (Calendar.current.component(.hour, from: Date()))
        
        if currentHour >= openHour && currentHour <= closeHour {
            Text(restaurant.openHour + " - " + restaurant.closeHour)
                .foregroundColor(.green)
                .font(.title2)
        } else {
            Text(LocalizedStringKey("restaurant-closed"))
                .foregroundColor(.red)
                .font(.title2)
        }
    }
}
