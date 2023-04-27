//
//  CookViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.04.2023.
//

import Combine
import FirebaseFirestore
import Foundation

final class CookViewModel: ObservableObject {
    @Published var user = MyUser()
    @Published var orders: [Order] = []
    @Published var restaurant = CurrentValueSubject<Restaurant, Never>(Restaurant())
    
    private var cancelables = [AnyCancellable]()
    
    func fetchAllOrders() {
        self.orders.removeAll()
        FSOrdersColl.shared.fetchOrdersForRestaurant(restaurantName: self.restaurant.value.name, completion: { orders in
            guard let orders = orders else {
                print("WorkerViewVM - Couldn't get orders from restaurant \(self.restaurant.value.name)")
                return
            }
            self.orders = orders.compactMap({ order in
                if order.orderState == .preparing {
                    return order
                }
                return nil
            })
        })
    }
    
    func acceptOrder(id: String) {
        FSOrdersColl.shared.changeOrderState(id: id)
    }
}

extension CookViewModel {
    
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
