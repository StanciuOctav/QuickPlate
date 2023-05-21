//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

private var tags: [String] = [LocalizedStringKey("booked-tables").stringValue(), LocalizedStringKey("favourite-restaurants").stringValue()]

struct UserProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var vm = UserProfileViewModel()
    @State private var selectedReservation = Table()
    
    @State private var isShowingCancelBooking: Bool = false
    @State private var isShowingSignOutAlert: Bool = false
    @State private var activeTag: String = tags[0]
    @State private var confirmedArrival: Bool = false
    @State private var confirmedBookingTableId: String = ""
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            TopSection()
            
            TagsView()
                .padding(.vertical, 10)
            
            switch activeTag {
            case LocalizedStringKey("booked-tables").stringValue():
                BookedTablesView()
            case LocalizedStringKey("favourite-restaurants").stringValue():
                FavouriteRestaurantsView()
            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $confirmedArrival) {
            NavigationView {
                ClientOrderView(tableId: self.$confirmedBookingTableId)
            }
        }
        .alert(LocalizedStringKey("cancel-reservation"), isPresented: $isShowingCancelBooking) {
            Button(LocalizedStringKey("yes"), role: .cancel) {
                vm.cancelBookingForTableWith(tableId: self.selectedReservation.id ?? "")
                self.isShowingCancelBooking.toggle()
            }
            Button(LocalizedStringKey("no"), role: .destructive) { }
        }
        .alert(LocalizedStringKey("signout-alert"), isPresented: $isShowingSignOutAlert) {
            Button(LocalizedStringKey("yes"), role: .cancel) {
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
            Button(LocalizedStringKey("no"), role: .destructive) { }
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
                                    Text(LocalizedStringKey("confirm-arrival"))
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
                                    Text(LocalizedStringKey("cancel"))
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
            Text(LocalizedStringKey("no-booked-tables"))
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
                VStack(alignment: .leading) {
                    HStack {
                        Text(vm.user.username)
                            .font(.title2)
                            .bold()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vm.user.firstName + " " + vm.user.lastName)
                            Text(vm.user.email)
                        }
                        Button {
                            self.isShowingSignOutAlert.toggle()
                        } label: {
                            Text(LocalizedStringKey("logout"))
                                .foregroundColor(Color.qpLightGrayColor)
                                .font(.subheadline)
                                .padding(.horizontal, 10)
                                .background(Capsule(style: .circular).foregroundColor(.black))
                        }
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
                Text(tag)
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
            Text(LocalizedStringKey("no-fav-restaurants"))
                .font(.headline)
            Spacer()
        }
    }
}
