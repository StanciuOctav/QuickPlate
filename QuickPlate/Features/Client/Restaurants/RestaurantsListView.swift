//
//  RestaurantsList.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct RestaurantsListView: View {
    @StateObject private var vm = RestaurantsListViewModel()
    @State private var searchRestaurant: String = ""
    @State private var changeStar: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.restaurants) { restaurant in
                    HStack {
                        NavigationLink(destination: RestaurantDetailsView(restaurant: restaurant)) {
                            RestaurantCardView(restaurant: restaurant.restaurantCardDTO)
                                .ignoresSafeArea(edges: [.leading, .trailing])
                        }
                        VStack(alignment: .trailing) {
                            Button {
                                vm.favouritesRes.contains(where: { $0 == restaurant.id}) ?
                                vm.removeRestFromFavs(resId: restaurant.id) :
                                vm.addFavouriteRestaurant(restaurantId: restaurant.id)
                            } label: {
                                Image(systemName: vm.isRestaurantFavourite(restaurant.id) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
                            }
                            Spacer()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .shadow(color: Color.qpBlackColor, radius: 3)
                    )
                    .padding([.top, .leading, .trailing], 10)
                }
            }
            .tint(Color.qpBlackColor)
            .background(Color.qpBeigeColor)
        }
        .tint(Color.qpOrange)
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
        .frame(maxWidth: .infinity)
        .task {
            await self.vm.fetchAllRestaurants()
            await self.vm.fetchFavouriteRestaurants()
        }
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsListView()
    }
}
