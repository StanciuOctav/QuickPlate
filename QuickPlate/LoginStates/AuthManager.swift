//
//  LoginManager.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 14.01.2023.
//

import Foundation
import SwiftUI

/** In UserDefaults we put for the key --login-- the following strings for different cases
 1. The user didn't sign in ever in app => nextScreen is .notSignedIn => will display the SignInView()
 2. The user signed in as a client => nextScreen is .clientSignedIn => will display the QPTabView()
 3. The user signed in as a worker => nextScreen is .workerSignedIn => will display the WorkerView()
 */

enum LoginStateEnum: String {
    case notSignedIn = "notSignedIn"
    case clientSignedIn = "clientSignedIn"
    case workerSignedIn = "workerSignedIn"
    
    var valueForUserDefaults: String {
        switch self {
        case .notSignedIn:
            return "notSignedIn"
        case .clientSignedIn:
            return "clientSignedIn"
        case .workerSignedIn:
            return "workerSignedIn"
        }
    }
}

final class AuthManager: ObservableObject {
    @Published var nextScreen: LoginStateEnum = .notSignedIn

    init() {
        checkLoginUserDefaultsExist()
    }
    
    func checkLoginUserDefaultsExist() {
        if (UserDefaults.standard.object(forKey: "login") == nil) {
            UserDefaults.standard.set(".notSignedIn", forKey: "login")
        } else {
            guard let cachedLoginState = UserDefaults.standard.string(forKey: "login") else {
                print("DEBUG - LoginManager - Error in reading the cached state")
                return
            }
            guard let newState = LoginStateEnum(rawValue: cachedLoginState) else {
                print("DEBUG - LoginManager - Error in getting the new state conversion")
                return
            }
            updateWith(state: newState)
        }
    }
    
    func updateWith(state: LoginStateEnum) {
        nextScreen = state
        if (state == .notSignedIn) {
            UserDefaults.standard.set(nextScreen.valueForUserDefaults, forKey: "login")
        }
    }
}
