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
    
    func signIn(completion: @escaping (Result<Int, StartupError>) -> Void) {
        FirebaseEmailAuth.shared.doLogin(email: email, password: password) { result in
            switch result {
            case let .success(userId):
                UserDefaults.standard.set(userId, forKey: "userId")
                FSUserColl.shared.fetchUserWith(id: userId) { myUser in
                    guard let myUser = myUser else {
                        print("SignInVM - Couldn't get user with id \(userId)")
                        return
                    }
                    if myUser.restaurantWorking.isEmpty {
                        UserDefaults.standard.set(LoginStateEnum.clientSignedIn.rawValue, forKey: "login")
                        completion(.success(1))
                    } else {
                        switch myUser.role {
                        case "Waiter":
                            UserDefaults.standard.set(LoginStateEnum.waiterSignedIn.rawValue, forKey: "login")
                            UserDefaults.standard.set(myUser.restaurantWorking, forKey: "restaurantWorking")
                            completion(.success(2))
                        case "Cook":
                            UserDefaults.standard.set(LoginStateEnum.cookSignedIn.rawValue, forKey: "login")
                            UserDefaults.standard.set(myUser.restaurantWorking, forKey: "restaurantWorking")
                            completion(.success(3))
                        default:
                            break
                        }
                    }
                }
            case .failure(.signInError):
                completion(.failure(.signInError))
            case .failure(.emailExists):
                completion(.failure(.emailExists))
            case .failure:
                print("Sign In failure")
            }
        }
    }
}
