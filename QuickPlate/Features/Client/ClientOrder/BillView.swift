//
//  BillView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.04.2023.
//

import SwiftUI

struct BillView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = BillViewModel()

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Your order")
                    .font(.title)
                Spacer()
                Text("Total: \(vm.totalCost, specifier: "%.2f")")
            }
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0 ..< vm.foods.count, id: \.self) { index in
                        HStack {
                            FoodCard(food: vm.foods[index])
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
        .padding()
        .alert("How do you want to pay?", isPresented: $vm.canPay) {
            Button("Cash") {
                self.vm.canPay.toggle()
                self.vm.selectedPaymentMethod.toggle()
            }
            Button("By card") {
                self.vm.canPay.toggle()
                self.vm.selectedPaymentMethod.toggle()
            }
            Button("Using the app") {
                self.vm.canPay.toggle()
                self.vm.selectedPaymentMethod.toggle()
            }
            Button("Go back", role: .cancel) {}
        }
        .alert("Our staff will get in touch with you shortly!", isPresented: $vm.selectedPaymentMethod) {
            Button("Ok", role: .cancel) {
                self.vm.selectedPaymentMethod.toggle()
                dismiss()
            }
        }
        .task {
            await self.vm.getOrders()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.canPay.toggle()
                } label: {
                    Text("Choose payment method")
                        .foregroundColor(Color.qpOrange)
                }
            }
        }
        .interactiveDismissDisabled()
    }
}