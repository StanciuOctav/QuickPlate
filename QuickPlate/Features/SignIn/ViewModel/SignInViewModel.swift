//
//  SignInViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Foundation
import FirebaseFirestore

final class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn(completion: @escaping (Error?) -> Void) {
        FirebaseEmailAuth.shared().doLogin(email: email, password: password) { error in
            if let error {
                print("SignInViewModel - Could not sign in")
                print(error.localizedDescription)
                completion(error)
            } else {
                print("SignInViewModel - User signed in")
                completion(nil)
            }
        }
    }
}
