//
//  WorkerViewViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 25.03.2023.
//

import FirebaseFirestore
import Foundation

final class WorkerViewViewModel: ObservableObject {
    @Published var user = MyUser()
    @Published var restaurant = Restaurant()
    @Published var orders: [Order] = []
    
    func fetchAllOrders() {
        
    }
}

extension WorkerViewViewModel {
    
    func fetchLoggedUserAndRes() async {
        await FSUserColl.shared.fetchLoggedUser(completion: { user in
            guard let user = user else { return }
            self.user = user
            let resId = UserDefaults.standard.string(forKey: "restaurantWorking") ?? ""
            print("Debug -- \(resId)")
            FSResColl.shared.getResWithId(resId: resId) { res in
                guard let res = res else {
                    print("WorkerViewVM - Couldn't retrive restaurant with id \(resId)")
                    return
                }
                self.restaurant = res
            }
        })
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
