//
//  UserStateViewModel.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Foundation

@MainActor
class UserStateViewModel: ObservableObject {
    @Published var isLoggedIn = false

    func signIn() {
        isLoggedIn = true
        // print("USER STATE SIGN IN \(isLoggedIn)")
    }

    func signOut() {
        isLoggedIn = false
        // print("USER STATE SIGN IN \(isLoggedIn)")
    }
}
