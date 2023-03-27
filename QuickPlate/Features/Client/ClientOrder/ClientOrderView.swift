//
//  ClientOrderView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 20.03.2023.
//

import SwiftUI

struct ClientOrderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ClientOrderViewModel()
    @State private var isShowingConfirmation: Bool = false
    @State private var noFoodOrdered: Bool = false
    @State private var requestedBill: Bool = false
    @State private var selectedPaymentMethod: Bool = false
    @Binding var tableId: String
    @Binding var confirmedArrival: Bool

    var body: some View {
        VStack {
            AllFoodsScrollView()
            Spacer()
            OrderedFoodsScrollView()
        }
        .frame(maxWidth: .infinity)
        .background(Color.qpBeigeColor)
        .alert("You want to send the order?", isPresented: $isShowingConfirmation) {
            Button("Yes", role: .cancel) {
                if vm.didOrderFood() {
                    isShowingConfirmation.toggle()
                    vm.sendOrder()
                } else {
                    isShowingConfirmation.toggle()
                    noFoodOrdered.toggle()
                }
            }
            Button("No", role: .destructive) {
                isShowingConfirmation.toggle()
            }
        }
        .alert("Sorry but you didn't order any food", isPresented: $noFoodOrdered) {
            Button("Ok", role: .cancel) {
                noFoodOrdered.toggle()
            }
        }
        .alert("How do you want to pay?", isPresented: $requestedBill) {
            Button("Cash") {
                self.requestedBill.toggle()
                self.selectedPaymentMethod.toggle()
            }
            Button("By card") {
                self.requestedBill.toggle()
                self.selectedPaymentMethod.toggle()
            }
            Button("Using the app") {
                self.requestedBill.toggle()
                self.selectedPaymentMethod.toggle()
            }
            Button("Go back", role: .cancel) {}
        }
        .alert("Our staff will get in touch with you shortly!", isPresented: $selectedPaymentMethod) {
            Button("Ok", role: .cancel) {
                vm.deleteBooking()
                self.selectedPaymentMethod.toggle()
                dismiss()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.resetOrder()
                } label: {
                    Text("Reset order")
                        .foregroundColor(Color.qpOrange)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isShowingConfirmation.toggle()
                } label: {
                    Text("Send order")
                        .foregroundColor(Color.qpOrange)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.requestedBill.toggle()
                } label: {
                    Text("Request bill")
                        .foregroundColor(Color.qpOrange)
                }
            }
        }
        .onAppear {
            self.vm.updateTableIdWith(id: self.tableId)
            Task {
                await self.vm.fetchFoodIds()
            }
        }
        .interactiveDismissDisabled()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func AllFoodsScrollView() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(vm.foods.enumerated()), id: \.offset) { index, food in
                    if food.stock > 0 {
                        HStack {
                            FoodCard(food: food)
                            Spacer()
                            VStack(alignment: .trailing) {
                                VStack(alignment: .center) {
                                    HStack {
                                        Button("-") {
                                            vm.decrementFood(index)
                                        }
                                        .disabled(vm.foods[index].stock == 0)
                                        Button("+") {
                                            vm.incrementFood(index)
                                        }
                                        .disabled(vm.foods[index].stock == 0)
                                    }
                                    Text(String(vm.numberOrdered[index]))
                                        .foregroundColor(vm.numberOrdered[index] < food.stock ? .black : .red)
                                }
                            }
                        }
                        .background(Color.qpLightGrayColor)
                        .padding([.bottom], 3)
                        .padding([.leading, .trailing], 6)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func OrderedFoodsScrollView() -> some View {
        VStack(alignment: .center) {
            HStack {
                Text("Your order")
                    .font(.title)
                Spacer()
                Text("Total: \(vm.totalCost, specifier: "%.2f")")
            }
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Array(vm.foods.enumerated()), id: \.offset) { index, food in
                        if vm.numberOrdered[index] > 0 {
                            HStack {
                                FoodCard(food: food)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    VStack(alignment: .center) {
                                        Text("x\(vm.numberOrdered[index])")
                                    }
                                }
                            }
                            .background(Color.qpLightGrayColor)
                            .padding([.bottom], 3)
                            .padding([.leading, .trailing], 6)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
