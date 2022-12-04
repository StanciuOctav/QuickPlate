//
//  FirebaseEmailAuth.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Foundation
import Firebase

class FirebaseEmailAuth {
    
    // MARK: SINGLETON
    private static let sharedFirebaseEmailAuth: FirebaseEmailAuth = {
        let share = FirebaseEmailAuth()
        return share
    }()
    
    class func shared() -> FirebaseEmailAuth {
        return sharedFirebaseEmailAuth
    }
    
    // MARK: AUTHENTICATION METHODS
    
    func doLogin(email: String = "", password: String = "", completion: @escaping (Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            if let error {
                completion(error)
            } else {
                guard let user = result?.user else {
                    print("FAILED: Anonymous Auth with firebase.")
                    return
                }
                print(user.email ?? "Not an email")
                completion(nil)
            }
        })
    }
    
    func doLogout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
