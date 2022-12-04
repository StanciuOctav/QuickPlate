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
    @Published var signInSuccessfull: Bool = false
    
    func loginUser() {
        FirebaseEmailAuth.shared().doLogin(email: email, password: password) { error in
            if let error = error {
                print("SignInViewModel - Could not sign in")
                print(error.localizedDescription)
            } else {
                print("SignInViewModel - User signed in")
                self.signInSuccessfull = true
            }
        }
    }
    
    func logoutUser() {
        FirebaseEmailAuth.shared().doLogout { error in
            if let error = error {
                print("SignInViewModel - Could not sign out")
                print(error.localizedDescription)
            } else {
                print("SignInViewModel - User signed out")
                self.signInSuccessfull = false
            }
        }
    }
    
    func isSignedIn() -> Bool {
        print("ENTER")
        return self.signInSuccessfull
    }
}
