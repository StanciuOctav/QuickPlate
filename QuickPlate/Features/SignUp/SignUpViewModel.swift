//
//  SignUpViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import FirebaseFirestore
import Foundation
import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    // FIXME: Maybe in the future have a list of working restaurants with DocumentReferences in them (REMEMBER: DocumentReference cannot be empty in firestore or it may not be a document at the specified path)
    @Published var restaurantId: String = ""

    var dropdownRoles = ["Client", "Chelner", "Barman", "Bucatar"]

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

    func setRestaurantId(withId id: String) {
        restaurantId = id
    }

    let db = Firestore.firestore()

    private func doSignUpAuth(completion: @escaping (Error?) -> Void) {
        FirebaseEmailAuth.shared().doSignUpAuth(withEmail: email, andPassword: password) { error in
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

    func doSignUp(withRole role: String) {
        doSignUpAuth { error in
            if let error {
                print("SignUpViewModel: doSignUp - Could not sign in")
                print(error.localizedDescription)
            } else {
                let newUser = MyUser(id: UUID().uuidString, username: self.username, firstName: self.firstName, lastName: self.lastName, role: role, restaurantWorking: self.restaurantId, email: self.email, password: self.password, favouriteRestaurants: [])
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
