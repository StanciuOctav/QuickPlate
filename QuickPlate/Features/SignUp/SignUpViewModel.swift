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

    var dropdownRoles = [LocalizedStringKey(stringLiteral: "client").stringValue(),
                         LocalizedStringKey(stringLiteral: "waiter").stringValue(),
                         LocalizedStringKey(stringLiteral: "bartender").stringValue(),
                         LocalizedStringKey(stringLiteral: "cook").stringValue()]

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

    func doSignUp(withRole role: String, completion: @escaping (Result<Int?, StartupError>) -> Void) {
        FirebaseEmailAuth.shared().doRegister(withEmail: email, andPassword: password) { result in
            switch result {
            case .success(_):
                let newUser = MyUser(id: UUID().uuidString, username: self.username, firstName: self.firstName, lastName: self.lastName, role: role, restaurantWorking: self.restaurantId, email: self.email, password: self.password, favouriteRestaurants: [])
                UserCollection.shared().saveUserToDB(user: newUser) { error in
                    if error != nil {
                        print("SignUpViewModel: doSignUp - Error in saving user to db")
                    } else {
                        print("SignUpViewModel: doSignUp - User saved to db")
                    }
                }
                completion(.success(1))
            case .failure(_):
                print("SignUpViewModel: doSignUp - Could not sign in")
                completion(.failure(.emailExists))
            }
        }
    }
}
