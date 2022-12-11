//
//  SignInViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import FirebaseFirestore
import Foundation

final class SignInViewModel: ObservableObject {
    // For user
    @Published var email: String = ""
    @Published var password: String = ""
    // For views
    @Published var showCredentialsErrors: Bool = false

    func setShowCredentialsErrors(withBool value: Bool) {
        showCredentialsErrors = value
    }

    func getShowCredentialsError() -> Bool {
        return showCredentialsErrors
    }

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
