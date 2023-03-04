//
//  UserCollection .swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import FirebaseFirestore
import Foundation

final class UserCollection {
    let usrColl = Firestore.firestore().collection("Users")
    static let shared = UserCollection()

    func saveUserToDB(user newUser: MyUser, completion: @escaping (Error?) -> Void) {
        // saving like this instead of saveDocument so we can have a custom DocumentId (to match the UID of the authentication user)
        usrColl.document(newUser.id!).setData([
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
    
    func saveBookedTable(withId tableId: String) {
        let userId = UserDefaults.standard.value(forKey: "userId") as! String
        let currUser = usrColl.document(userId)
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
