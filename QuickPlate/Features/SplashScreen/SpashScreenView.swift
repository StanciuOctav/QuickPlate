//
//  SpashScreenView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 13.11.2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = true
    @StateObject var loginManager = LoginManager()

    var body: some View {
        if isActive {
            switch loginManager.nextScreen {
            case .notSignedIn:
                SignInView(loginManager: loginManager)
            case .clientSignedIn:
                QPTabView(loginManager: loginManager)
            case .workerSignedIn:
                QPTabView(loginManager: loginManager) // FIXME: replace this with worker's home screen
            }
        } else {
            ZStack {
                Color("qp-beige-color").ignoresSafeArea()
                VStack {
                    Image("app-icon")
                    Text("QuickPlate")
                        .font(.system(size: 40))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
