//
//  RootView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 15.03.2023.
//

import SwiftUI

struct RootView: View {
    @StateObject var authManager = AuthManager()
    @State private var isShowingSplash = false
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashScreenView(showing: $isShowingSplash)
            } else {
                switch authManager.nextScreen {
                case .notSignedIn:
                    NavigationStack {
                        SignInView()
                    }
                case .clientSignedIn:
                    QPTabView()
                case .waiterSignedIn:
                    WaiterView()
                case .cookSignedIn:
                    CookView()
                }
            }
        }
        .environmentObject(authManager)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
