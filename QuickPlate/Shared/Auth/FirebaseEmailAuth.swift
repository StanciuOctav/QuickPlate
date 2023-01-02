//
//  FirebaseEmailAuth.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Firebase
import Foundation

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

    func doLogin(email: String = "", password: String = "", completion: @escaping (Result<Int?, StartupError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard result != nil else {
                if let error {
                    print(error.localizedDescription)
                }
                completion(.failure(.signInError))
                return
            }
            guard (result?.user) != nil else {
                completion(.failure(.anonymousUser))
                return
            }
            completion(.success(1))
        })
    }

    func doSignUpAuth(withEmail email: String, andPassword password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error { completion(error) } else {
                guard let user = result?.user else {
                    print("FAILED: creating user")
                    return
                }
                print("USER CREATED \(user.email ?? "noemail")")
                completion(nil)
            }
        }
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
