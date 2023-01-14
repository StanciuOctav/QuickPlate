//
//  LoginManager.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 14.01.2023.
//

import Foundation

/** In UserDefaults we put for the key --login-- the following strings for different cases
 1. The user didn't sign in ever in app => nextScreen is .notSignedIn => will display the SignInView()
 2. The user signed in as a client => nextScreen is .clientSignedIn => will display the QPTabView()
 3. The user signed in as a worker => nextScreen is .workerSignedIn => will display the WorkerView()
 */

enum LoginState {
    case notSignedIn
    case clientSignedIn
    case workerSignedIn
}

final class LoginManager: ObservableObject {
    @Published var nextScreen: LoginState = .notSignedIn

    init() {
        checkLoginUserDefaultsExist()
    }
    
    func checkLoginUserDefaultsExist() {
        if (UserDefaults.standard.object(forKey: "login") == nil) {
            UserDefaults.standard.set(".notSignedIn", forKey: "login")
            nextScreen = .notSignedIn
        } else {
            updateNextScreenWithSavedState(state: UserDefaults.standard.string(forKey: "login")!)
        }
    }
    
    func updateNextScreenWithSavedState(state: String){
        switch state {
        case "notSignedIn":
            nextScreen = .notSignedIn
            break
        case "clientSignedIn":
            nextScreen = .clientSignedIn
            break
        case "workerSignedIn":
            nextScreen = .workerSignedIn
            break
        default:
            break
        }
    }
    
    func updateWith(state: LoginState) {
        if (state == .notSignedIn) {
            UserDefaults.standard.removeObject(forKey: "login")
        }
        nextScreen = state
    }
}
