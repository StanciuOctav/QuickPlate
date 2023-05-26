//
//  OrderCard.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import SwiftUI

struct OrderCardView: View {
    @StateObject private var vm = OrderCardViewModel()
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Table: \(order.tableNr)")
                .bold()
                .font(.title2)
                .padding([.bottom], 5)
            VStack(alignment: .leading) {
                ForEach(vm.foods) { food in
                    let index = vm.foods.firstIndex(of: food)
                    HStack {
                        Text("\(food.foodName)")
                        Spacer()
                        Text("x\(order.foodQuantity[index ?? 0])")
                            .padding([.trailing], 3)
                        Text("\(String(format: "%.2f", food.price * Double(order.foodQuantity[index ?? 0]))) lei")
                    }
                }
                Text("Total: \(String(format: "%.2f", order.totalCost))")
                    .padding([.top], 5)
                    .bold()
            }
        }
        .background(Color.qpLightGrayColor)
        .padding()
        .onAppear {
            self.vm.fetchFoodsFor(order: self.order)
        }
    }
}
