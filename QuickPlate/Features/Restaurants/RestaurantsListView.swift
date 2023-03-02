//
//  RestaurantsList.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct RestaurantsListView: View {
    @StateObject var vm = RestaurantsListViewModel()
    @State var searchRestaurant: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.restaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailsView(restaurant: restaurant)) {
                        RestaurantCardView(restaurant: RestaurantCardDTO(from: restaurant))
                            .ignoresSafeArea(.all, edges: [.leading, .trailing])
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .searchable(text: $searchRestaurant,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: LocalizedStringKey("search-placeholder"))
        .autocorrectionDisabled(true)
        .onChange(of: searchRestaurant) { searchTerm in
            if !searchTerm.isEmpty {
                vm.restaurants = vm.restaurants.filter({ restaurant in
                    restaurant.name.lowercased().contains(searchTerm.lowercased())
                })
            } else {
                vm.resetRestaurants()
            }
        }
        .onSubmit({
            self.searchRestaurant = ""
        })
        .ignoresSafeArea(.all, edges: [.trailing, .leading])
        .frame(maxWidth: .infinity)
        .scrollContentBackground(.hidden)
        .task {
            await self.vm.fetchAllRestaurants()
        }
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsListView()
    }
}
