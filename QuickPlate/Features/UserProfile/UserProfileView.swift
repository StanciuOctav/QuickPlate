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
            Text("Logout")
        }
    }
 }

struct UserProfileView: View {
    @StateObject var vm = UserProfileViewModel()
    @ObservedObject var loginManager: LoginManager
    // let user: MyUser

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
                    LogoutButton(vm: self.vm, loginManager: self.loginManager)
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
                ForEach(vm.bookedTables, id: \.self.id) { table in
                    HStack {
                        BookedTableView(table: table)
                        Spacer()
                        Button {
                            
                        } label: {
                             Text("Confirm arrival")
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .task {
            await self.vm.fetchLoggedUser()
        }
        .background(Color.qpLightGrayColor)
        .toolbar {
            Button {
            } label: {
                HStack {
                    Text("Sign out")
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                .foregroundColor(Color.white)
            }
        }
    }
}
