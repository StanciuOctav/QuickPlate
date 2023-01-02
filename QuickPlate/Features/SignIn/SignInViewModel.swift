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

    func signIn(completion: @escaping (Result<Int?,StartupError>) -> Void) {
        FirebaseEmailAuth.shared().doLogin(email: email, password: password) { result in
            switch result {
            case .success(_):
                completion(.success(1))
            case .failure(.signInError):
                completion(.failure(.signInError))
            case .failure(_):
                print("Sign In failure")
            }
        }
    }
}
