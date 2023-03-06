//
//  UserCollection .swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import FirebaseFirestore
import Foundation

final class FSUserColl {
    let coll = Firestore.firestore().collection(FSCollNames.users.rawValue)
    static let shared = FSUserColl()

    func saveUserToDB(user newUser: MyUser, completion: @escaping (Error?) -> Void) {
        // saving like this instead of saveDocument so we can have a custom DocumentId (to match the UID of the authentication user)
        coll.document(newUser.id!).setData([
            "username": newUser.username,
            "firstName": newUser.firstName,
            "lastName": newUser.lastName,
            "role": newUser.role,
            "restaurantWorking": newUser.restaurantWorking,
            "email": newUser.email,
            "password": newUser.password,
            "favouriteRestaurants": newUser.favouriteRestaurants,
            "bookedTables": newUser.bookedTables
        ])
        completion(nil)
    }
    
    func fetchLoggedUser(completion: @escaping (MyUser?) -> Void) async {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        coll.document(userId).addSnapshotListener { qdSnap, error in
            if let error = error {
                print("UserCollection - Could't retrieve logged user")
                print(error.localizedDescription)
                completion(nil)
            }
            guard let qdSnap = qdSnap else {
                print("UserCollection - There is no user with the id \(userId)")
                completion(nil)
                return
            }
            completion(try? qdSnap.data(as: MyUser.self))
        }
    }
    
    func saveBookedTable(withId tableId: String) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        let currUser = coll.document(userId)
        currUser.getDocument { qdSnap, error in
            if let error = error {
                print("TablesViewVM - Couldn't assign booked table to user")
                print(error.localizedDescription)
            }
            if let qdSnap = qdSnap, let document = try? qdSnap.data(as: MyUser.self) {
                var newBookedTablesArr = document.bookedTables
                newBookedTablesArr.append(tableId)
                currUser.updateData(["bookedTables": newBookedTablesArr])
            }
        }
    }
}
