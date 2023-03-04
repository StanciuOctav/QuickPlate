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

    private let coll = Firestore.firestore().collection("Users")
    private let tColl = Firestore.firestore().collection("Tables")
    private let rColl = Firestore.firestore().collection("Restaurants")


    func fetchLoggedUser() async {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        coll.document(userId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("UserCollection - Could't retrieve logged user")
                print(error.localizedDescription)
            }
            guard let querySnapshot = querySnapshot else {
                print("UserCollection - There is no user with the id \(userId)")
                return
            }
            do {
                self.user = try querySnapshot.data(as: MyUser.self)
                self.updateBookedTables(self.user)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }

    func updateBookedTables(_ user: MyUser) {
        bookedTables.removeAll()
        for tId in user.bookedTables {
            tColl.document(tId).getDocument { qdSnap, error in
                if let error = error {
                    print("UserProfileVM - Couldn't get booked table with id \(tId)")
                    print(error.localizedDescription)
                }

                if let qdSnap = qdSnap, let table = try? qdSnap.data(as: Table.self) {
                    self.bookedTables.append(table)
                }
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
