//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

private enum SelectedTab: String {
    case bookedTables = "Booked Tables"
    case favRests = "Favourite Restaurants"
}

private var tags: [SelectedTab] = [.bookedTables, .favRests]

struct UserProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var vm = UserProfileViewModel()
    @State private var selectedReservation = Table()

    @State private var isShowingCancelBooking: Bool = false
    @State private var isShowingSignOutAlert: Bool = false
    @State private var activeTag: SelectedTab = tags[0]
    @State private var confirmedArrival: Bool = false
    @State private var confirmedBookingTableId: String = ""

    @Namespace private var animation

    var body: some View {
        VStack {
            TopSection()

            TagsView()
                .padding(.vertical, 10)

            switch activeTag {
            case .bookedTables:
                BookedTablesView()
            case .favRests:
                FavouriteRestaurantsView()
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $confirmedArrival) {
            NavigationView {
                ClientOrderView(tableId: self.$confirmedBookingTableId, confirmedArrival: $confirmedArrival)
            }
        }
        .alert("Are you sure you want to cancel the reservation?", isPresented: $isShowingCancelBooking) {
            Button("Yes", role: .cancel) {
                vm.cancelBookingForTableWith(tableId: self.selectedReservation.id ?? "")
                self.isShowingCancelBooking.toggle()
            }
            Button("No", role: .destructive) { }
        }
        .alert("Are you sure you want to Sign Out?", isPresented: $isShowingSignOutAlert) {
            Button("Yes", role: .cancel) {
                vm.signOut(completion: { didNotSignOut in
                    guard let _ = didNotSignOut else {
                        print("UserProfileView - The user couldn't sign out")
                        return
                    }
                    print("The user signed out")
                    authManager.updateWith(state: .notSignedIn)
                })
                self.isShowingSignOutAlert.toggle()
            }
            Button("No", role: .destructive) { }
        }
        .task {
            await self.vm.fetchLoggedUser()
            await self.vm.fetchFavRests()
        }
        .background(Color.qpBeigeColor)
    }

    @ViewBuilder
    func BookedTablesView() -> some View {
        if !vm.user.bookedTables.isEmpty {
            ScrollView {
                ForEach(vm.bookedTables, id: \.self.id) { table in
                    HStack {
                        BookedTableView(table: table)

                        Spacer()
                        VStack(alignment: .trailing) {
                            Button {
                                self.confirmedArrival.toggle()
                                self.confirmedBookingTableId = table.id ?? ""
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .fixedSize()
                                    Text("Confirm arrival")
                                }
                                .foregroundColor(.green)
                            }
                            Button {
                                self.selectedReservation = table
                                self.isShowingCancelBooking.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "x.circle.fill")
                                        .resizable()
                                        .fixedSize()
                                    Text("Cancel")
                                }
                                .foregroundColor(.red)
                            }
                        }
                        .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.01), radius: 8, x: 5, y: 5)
                    }
                    .padding(.horizontal, 10)
                }
            }
        } else {
            Spacer()
            Text("You don't have any booked tables at the moment")
                .font(.headline)
            Spacer()
        }
    }

    @ViewBuilder
    func TopSection() -> some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                VStack(alignment: .leading, spacing: 3) {
                    Text(vm.user.username)
                        .font(.title2)
                        .bold()
                    Text(vm.user.firstName + " " + vm.user.lastName)
                    Text(vm.user.email)
                }
                Spacer()
                VStack {
                    Button {
                        self.isShowingSignOutAlert.toggle()
                    } label: {
                        Text("Sign out")
                            .foregroundColor(Color.qpLightGrayColor)
                            .padding(.horizontal, 10)
                            .background(Capsule(style: .circular).foregroundColor(.black))
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 6)
        .background(Color.qpOrange)
    }

    @ViewBuilder
    func TagsView() -> some View {
        HStack(alignment: .center) {
            ForEach(tags, id: \.self) { tag in
                Text(tag.rawValue)
                    .font(.caption)
                    .padding(.all, 10)
                    .background {
                        if activeTag == tag {
                            Capsule()
                                .fill(Color.qpOrange)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        } else {
                            Capsule()
                                .fill(.white)
                        }
                    }
                    .foregroundColor(activeTag == tag ? .white : .black)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                            activeTag = tag
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func FavouriteRestaurantsView() -> some View {
        if !vm.user.favouriteRestaurants.isEmpty {
            ScrollView {
                ForEach(vm.favouriteRestaurants, id: \.self.id) { restaurant in
                    HStack {
                        RestaurantCardView(restaurant: restaurant.restaurantCardDTO)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.01), radius: 8, x: 5, y: 5)
                    }
                    .padding(.horizontal, 10)
                }
            }
        } else {
            Spacer()
            Text("You don't have any favourite restaurants yet")
                .font(.headline)
            Spacer()
        }
    }
}
