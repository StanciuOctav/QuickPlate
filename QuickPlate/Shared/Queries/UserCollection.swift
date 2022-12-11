//
//  UserCollection .swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import FirebaseFirestore
import Foundation

final class UserCollection {
    let usrColl = Firestore.firestore().collection("User")

    // MARK: SINGLETON

    private static let sharedUserCollection: UserCollection = {
        let share = UserCollection()
        return share
    }()

    class func shared() -> UserCollection {
        return sharedUserCollection
    }

    func saveToDB(user newUser: MyUser, completion: @escaping (Error?) -> Void) {
        do {
            _ = try usrColl.addDocument(from: newUser)
            completion(nil)
        } catch let error {
            print(error.localizedDescription)
            completion(error)
        }
    }
}
