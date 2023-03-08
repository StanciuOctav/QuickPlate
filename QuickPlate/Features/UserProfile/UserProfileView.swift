//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct LogoutButton: View {
    @ObservedObject var vm: UserProfileViewModel
    @ObservedObject var loginManager: LoginManager

    var body: some View {
        Button {
            vm.signOut(completion: { didNotSignOut in
                if didNotSignOut != nil {
                    print("UserProfileView - The user couldn't sign out")
                } else {
                    print("Did the user sign out? \(didNotSignOut != nil ? "NO" : "YES")")
                    loginManager.updateWith(state: .notSignedIn)
                }
            })
        } label: {
            Text("Sign out")
                .foregroundColor(Color.qpLightGrayColor)
                .padding(.horizontal, 10)
                .background(Capsule(style: .circular).foregroundColor(.black))
        }
    }
}

struct UserProfileView: View {
    @StateObject var vm = UserProfileViewModel()
    @ObservedObject var loginManager: LoginManager
    
    @State var confirmCancel: Bool = false
    @State var selectedReservation = Table()

    var body: some View {
        VStack {
            VStack {
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
                        LogoutButton(vm: self.vm, loginManager: self.loginManager)
                        Spacer()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 6)
            .background(Color.qpOrange)

            if !vm.user.bookedTables.isEmpty {
                HStack {
                    Text("Booked tables")
                        .font(.title2)
                    Spacer()
                }
                .padding()
                ScrollView {
                    ForEach(vm.bookedTables, id: \.self.id) { table in
                        HStack {
                            BookedTableView(table: table)
                            
                            Spacer()
                            VStack(alignment: .trailing) {
                                Button {
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
                                    self.confirmCancel.toggle()
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
            }
            Spacer()
        }
        .alert("Are you sure you want to cancel the reservation?", isPresented: $confirmCancel) {
            Button("Yes", role: .cancel) {
                vm.cancelBookingForTableWith(tableId: self.selectedReservation.id ?? "")
                self.confirmCancel.toggle()
            }
            Button("No", role: .destructive) { }
        }
        .task {
            await self.vm.fetchLoggedUser()
        }
        .background(Color.qpLightGrayColor)
    }
}
