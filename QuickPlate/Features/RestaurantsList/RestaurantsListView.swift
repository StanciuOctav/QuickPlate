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
        NavigationView {
            List(vm.restaurants) { restaurant in
                NavigationLink(destination: RestaurantDetailsView(restaurant: restaurant)) {
                    RestaurantCardView(restaurant: RestaurantCardDTO(from: restaurant))
                }
                .border(.black)
                .listRowInsets(EdgeInsets(top: 5, leading: 1, bottom: 5, trailing: 1))
                .listRowSeparator(.hidden)
            }
            .border(.black)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
