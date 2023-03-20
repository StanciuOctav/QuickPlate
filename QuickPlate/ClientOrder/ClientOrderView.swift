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
    @Binding var tableId: String
    @Binding var confirmedArrival: Bool

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Array(vm.foods.enumerated()), id: \.offset) { index, food in
                        HStack {
                            FoodCard(food: food)
                            Spacer()
                            VStack(alignment: .trailing) {
                                VStack(alignment: .center) {
                                    HStack {
                                        Button("-") {
                                            vm.decrementFood(index)
                                        }
                                        Button("+") {
                                            vm.incrementFood(index)
                                        }
                                    }
                                    Text(String(vm.numberOrdered[index]))
                                        .foregroundColor(vm.numberOrdered[index] < food.stoc ? .black : .red)
                                }
                                Spacer()
                                if food.stoc != 0 {
                                    Text("In stock")
                                        .foregroundColor(.green)
                                } else {
                                    Text("Out of stock")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .background(Color.qpLightGrayColor)
                        .padding([.bottom], 3)
                        .padding([.leading, .trailing], 6)
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.qpBeigeColor)
        .alert("You want to send the order?", isPresented: $isShowingConfirmation) {
            Button("Yes", role: .cancel) {
                isShowingConfirmation.toggle()
                confirmedArrival.toggle()
            }
            Button("No", role: .destructive) {
                isShowingConfirmation.toggle()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingConfirmation.toggle()
                } label: {
                    Text("Send order")
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
    }
}
