//
//  UserProfileViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import FirebaseFirestore
import Foundation

final class UserProfileViewModel: ObservableObject {
    @Published var user = MyUser()
    @Published var bookedTables = [Table]()

    func fetchLoggedUser() async {
        await FSUserColl.shared.fetchLoggedUser(completion: { user in
            guard let user = user else { return }
            self.user = user
            self.updateBookedTables(self.user)
        })
    }

    func updateBookedTables(_ user: MyUser) {
        bookedTables.removeAll()
        for tId in user.bookedTables {
            FSTableColl.shared.getTableWith(id: tId) { table in
                guard let table = table else { return }
                if !self.bookedTables.contains(where: { $0.id == table.id }) {
                    self.bookedTables.append(table)
                }
            }
        }
    }
    
    func cancelBookingForTableWith(tableId: String) {
        FSUserColl.shared.deleteBookedTableWith(tableId: tableId) { res in
            switch res {
            case 1:
                FSTableColl.shared.resetBookedTableWith(tableId: tableId)
                break
            case -1:
                print("UserProfileVM - error in deleting a reservation")
                break
            default:
                break
            }
        }
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
