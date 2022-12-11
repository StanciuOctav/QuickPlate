//
//  SignUpViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    var dropdownRoles = ["Client", "Chelner", "Barman", "Bucatar"]
    // TODO: Populate dropdownRestaurant with those from DB
    var dropdownRestaurants = ["Marty", "Samsara", "Noir"]

    var passwordWrongFormat: Bool {
        return passwordHasWrongFormat()
    }

    var passwordsAreDifferent: Bool {
        return passwordsDontMatch()
    }

    private func passwordHasWrongFormat() -> Bool {
        return password.count < 6 || password == ""
    }

    private func passwordsDontMatch() -> Bool {
        return password == "" || confirmPassword == "" || password != confirmPassword
    }
    
    func allFieldsAreCompleted() -> Bool {
        return username != "" &&
        firstName != "" &&
        lastName != "" &&
        email != ""
    }
    
    let db = Firestore.firestore()
    
    private func doSignUpAuth(completion: @escaping (Error?) -> Void) {
        FirebaseEmailAuth.shared().doSignUpAuth(withEmail: self.email, andPassword: self.password) { error in
            if let error {
                print("SignUpViewModel: doSignUpAuth - Could not sign in")
                print(error.localizedDescription)
                completion(error)
            } else {
                print("SignUpViewModel: doSignUpAuth - User signed in")
                completion(nil)
            }
        }
    }
    
    func doSignUp(withRole role: String, andRestaurant rest: String) {
        self.doSignUpAuth { error in
            if let error {
                print("SignUpViewModel: doSignUp - Could not sign in")
                print(error.localizedDescription)
            } else {
                guard let newUser = MyUser(username: self.username, firstName: self.firstName, lastName: self.lastName, role: role, restaurantWorking: rest, email: self.email, password: self.password, favouriteRestaurants: []) else {return}
                UserCollection.shared().saveToDB(user: newUser) { error in
                    if error != nil {
                        print("SignUpViewModel: doSignUp - Error in saving user to db")
                    } else {
                        print("SignUpViewModel: doSignUp - User saved to db")
                    }
                }
            }
        }
    }
}
