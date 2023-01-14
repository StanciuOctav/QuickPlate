//
//  LoginStateView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 14.01.2023.
//

import SwiftUI

struct LoginStateView: View {
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        switch loginManager.nextScreen {
        case .notSignedIn:
            SignInView(loginManager: loginManager)
        case .clientSignedIn:
            QPTabView(loginManager: loginManager)
        case .workerSignedIn:
            QPTabView(loginManager: loginManager) // replace this with worker's home screen
        }
    }
}

struct LoginStateView_Previews: PreviewProvider {
    static var previews: some View {
        LoginStateView()
    }
}
