//
//  FirebaseEmailAuth.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Firebase
import Foundation

enum StartupError: Error {
    case signInError
    case signUpError
    case anonymousUser
    case emailExists
}

class FirebaseEmailAuth {
    static let shared = FirebaseEmailAuth()
    
    // MARK: AUTHENTICATION METHODS
    
    func doLogin(email: String = "", password: String = "", completion: @escaping (Result<String, StartupError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard result != nil else {
                if let error {
                    print(error.localizedDescription)
                }
                completion(.failure(.signInError))
                return
            }
            guard let user = result?.user else {
                completion(.failure(.anonymousUser))
                return
            }
            completion(.success(user.uid))
//            switch user.isEmailVerified {
//            case true:
//                print("Email is verified")
//                completion(.success(user.uid))
//            case false:
//                print("Email is not verified")
//                completion(.failure(.emailExists))
//            }
        })
    }
    
    func doRegister(withEmail email: String, andPassword password: String, completion: @escaping (Result<String, StartupError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil else {
                if let error {
                    print(error.localizedDescription)
                }
                completion(.failure(.signUpError))
                return
            }
            guard let user = result?.user else {
                completion(.failure(.anonymousUser))
                return
            }
            completion(.success(user.uid))
//            switch user.isEmailVerified {
//            case true:
//                print("Email is verified")
//                completion(.success(user.uid))
//            case false:
//                print("Email is not verified")
//                user.sendEmailVerification { error in
//                    guard let _ = error else {
//                        completion(.success(user.uid))
//                        return
//                    }
//                    completion(.failure(.emailExists))
//                }
//            }
        }
    }
    
    func doLogout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
