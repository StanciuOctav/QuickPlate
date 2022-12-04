//
//  UserProfileViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    
    func signOut(completion: @escaping (Error?) -> Void) {
        FirebaseEmailAuth.shared().doLogout { error in
            if let error = error {
                print("SignInViewModel - Could not sign out")
                print(error.localizedDescription)
                completion(error)
            } else {
                print("SignInViewModel - User signed out")
                completion(nil)
            }
        }
    }
}
