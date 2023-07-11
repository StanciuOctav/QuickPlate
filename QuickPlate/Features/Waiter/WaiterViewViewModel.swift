//
//  WorkerViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import Combine
import FirebaseFirestore
import Foundation

final class WaiterViewViewModel: ObservableObject {
    @Published var user = MyUser()
    @Published var orders: [Order] = []
    @Published var restaurant = CurrentValueSubject<Restaurant, Never>(Restaurant())
    @Published var canTakeOrder: Bool = true
    
    private var cancelables = [AnyCancellable]()
    private let maxNumberOfOrders = 2
    
    init() {
        canAcceptOrders()
    }
    
    func fetchAllOrders() {
        self.orders.removeAll()
        FSOrdersColl.shared.fetchOrdersForRestaurant(restaurantName: self.restaurant.value.name, completion: { orders in
            guard let orders = orders else {
                print("WorkerViewVM - Couldn't get orders from restaurant \(self.restaurant.value.name)")
                return
            }
            self.orders = orders.compactMap({ order in
                if order.orderState == .pending || order.orderState == .ready {
                    return order
                }
                return nil
            })
        })
    }
    
    func acceptOrder(id: String, state: OrderState) {
        var currentNumber = UserDefaults.standard.integer(forKey: "ordersAccepted")
        if state == .pending {
            currentNumber += 1
        }
        if state == .ready {
            currentNumber -= 1
        }
        if currentNumber > maxNumberOfOrders {
            currentNumber = maxNumberOfOrders
        }
        UserDefaults.standard.set(currentNumber, forKey: "ordersAccepted")
        FSOrdersColl.shared.changeOrderState(id: id)
        canAcceptOrders()
    }
    
    func removeOrder(_ id: String) {
        var currentNumber = UserDefaults.standard.integer(forKey: "ordersAccepted")
        currentNumber = currentNumber - 1 < 0 ? 0 : currentNumber - 1 // if the order is canceled than the number of accepted orders must decrement
        UserDefaults.standard.set(currentNumber, forKey: "ordersAccepted")
        
        for order in self.orders {
            if order.id == id {
                for index in 0..<order.foodIds.count {
                    FSFoodsColl.shared.updateFoodstockkWith(id: order.foodIds[index], nrOrdered: order.foodQuantity[index], addStock: true)
                }
            }
        }
        FSOrdersColl.shared.deleteOrderWith(id: id)
        self.canAcceptOrders()
    }
    
    private func canAcceptOrders() {
        var currNumber = 0
        if (UserDefaults.standard.object(forKey: "ordersAccepted") == nil) {
            UserDefaults.standard.set(0, forKey: "ordersAccepted")
        } else {
            currNumber = UserDefaults.standard.integer(forKey: "ordersAccepted")
        }
        canTakeOrder =  !(currNumber >= maxNumberOfOrders)
    }
}

extension WaiterViewViewModel {
    
    func fetchLoggedUserAndRes() async {
        await FSUserColl.shared.fetchLoggedUser(completion: { user in
            guard let user = user else { return }
            self.user = user
            let resId = UserDefaults.standard.string(forKey: "restaurantWorking") ?? ""
            FSResColl.shared.getResWithId(resId: resId) { res in
                guard let res = res else {
                    print("WorkerViewVM - Couldn't retrive restaurant with id \(resId)")
                    return
                }
                self.restaurant.value = res
            }
        })
        self.restaurant.sink { [unowned self] _ in
            self.fetchAllOrders()
        }.store(in: &self.cancelables)
    }
    
    func signOut(completion: @escaping (Int?) -> Void) {
        FirebaseEmailAuth.shared.doLogout { error in
            if let error = error {
                print("UserProfileViewModel - Could not sign out")
                print(error.localizedDescription)
                completion(nil)
            } else {
                print("UserProfileViewModel - User signed out")
                completion(1)
            }
        }
    }
}
