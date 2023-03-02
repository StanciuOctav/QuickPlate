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
        ])
        completion(nil)
    }
}
