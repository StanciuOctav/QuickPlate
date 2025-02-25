//
//  WorkerView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import SwiftUI

struct WaiterView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var vm = WaiterViewViewModel()
    
    @State private var isShowingSignOutAlert: Bool = false
    
    var body: some View {
        VStack {
            TopSection()
            if vm.orders.isEmpty {
                Text(LocalizedStringKey("employee-no-orders"))
                    .font(.title2)
                Spacer()
            } else {
                Spacer()
                ScrollView {
                    ForEach(vm.orders, id: \.self.id) { order in
                        VStack {
                            OrderCardView(order: order)
                                .cornerRadius(4)
                            HStack {
                                Button {
                                    // add the order to the bill
                                    self.vm.acceptOrder(id: order.id ?? "", state: order.orderState)
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                    if order.orderState == .pending {
                                        Text(LocalizedStringKey("send-to-kitchen"))
                                    } else if order.orderState == .ready {
                                        Text(LocalizedStringKey("deliver-order"))
                                    }
                                }
                                .disabled(!vm.canTakeOrder && order.orderState == .pending)
                                .foregroundColor(!vm.canTakeOrder && order.orderState == .pending ? .gray : .green)
                                Spacer()
                                Button {
                                    // This should be pressed when the restaurant doesn't have some igredients
                                    self.vm.removeOrder(order.id ?? "")
                                } label: {
                                    Image(systemName: "x.circle")
                                    Text(LocalizedStringKey("reject-order"))
                                }
                                .foregroundColor(.red)
                            }
                            .padding([.bottom, .leading, .trailing], 5)
                        }
                        .background(Color.qpLightGrayColor)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
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
                        Text(LocalizedStringKey("logout"))
                            .foregroundColor(Color.qpLightGrayColor)
                            .padding(.horizontal, 10)
                            .background(Capsule(style: .circular).foregroundColor(.black))
                    }
                }
            }
            .padding()
            HStack {
                Spacer()
                Text(LocalizedStringKey("works-at"))
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
