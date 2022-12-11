//
//  SignUpViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Foundation
import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var selectedRole: String = ""
    var dropdownRoles = ["Client", "Chelner", "Barman", "Bucatar"]

    @Published var selectedRestaurant: String = ""
    var dropdownRestaurants = ["Marty", "Samsara", "Noir"]
    var isRestaurantDisabled: Bool {
        !(selectedRole != "Client" && !selectedRole.isEmpty)
    }

    @Published private var isPasswordSecure: Bool = true
    @Published private var isConfirmPasswordSecure: Bool = true

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
}
