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

    private let coll = Firestore.firestore().collection(FSCollNames.users.rawValue)

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
                self.bookedTables.append(table)
            }
        }
    }

    func signOut(completion: @escaping (Error?) -> Void) {
        FirebaseEmailAuth.shared.doLogout { error in
            if let error = error {
                print("UserProfileViewModel - Could not sign out")
                print(error.localizedDescription)
                completion(error)
            } else {
                print("UserProfileViewModel - User signed out")
                completion(nil)
            }
        }
    }
}
