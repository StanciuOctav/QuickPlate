//
//  RestaurantsList.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct RestaurantsListView: View {
    @StateObject var vm = RestaurantsViewViewModel()
    @State var searchRestaurant: String = ""

    var body: some View {
        List(vm.restaurants) { restaurant in
            RestaurantCardView(restaurant: restaurant)
                .listRowInsets(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 3))
                .listRowSeparator(.hidden)
        }
        .searchable(text: $searchRestaurant, prompt: LocalizedStringKey("search-placeholder"))
        .onChange(of: searchRestaurant) { searchTerm in
            if !searchTerm.isEmpty {
                vm.restaurants = vm.restaurants.filter({ restaurant in
                    restaurant.name.lowercased().contains(searchTerm.lowercased())
                })
            } else {
                vm.fetchAllRestaurants()
            }
        }
        .onSubmit({
            self.searchRestaurant = ""
        })
        .ignoresSafeArea(.all, edges: [.trailing, .leading])
        .frame(maxWidth: .infinity)
        .scrollContentBackground(.hidden)
        .onAppear {
            self.vm.fetchAllRestaurants()
        }
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsListView()
    }
}
