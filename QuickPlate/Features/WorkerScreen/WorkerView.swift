//
//  WorkerView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import SwiftUI

struct WorkerView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var vm = WorkerViewViewModel()

    @State private var isShowingSignOutAlert: Bool = false

    var body: some View {
        VStack {
            TopSection()
            Spacer()
            ScrollView {
                ForEach(vm.orders, id: \.self.id) { order in
                    HStack {
                        OrderCard(order: order)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
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
            await self.vm.fetchLoggedUserAndRes()
        }
        .background(Color.qpBeigeColor)
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
            HStack {
                Spacer()
                Text("Works for:")
                Text(vm.restaurant.value.name)
                    .bold()
                Spacer()
            }
            .padding([.bottom], 10)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 6)
        .background(Color.qpOrange)
    }
}
