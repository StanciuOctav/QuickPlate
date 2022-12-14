//
//  QuickPlateApp.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 13.11.2022.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct QuickPlateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var userStateViewModel = UserStateViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
//                QPTabView()
            }
            .environmentObject(userStateViewModel)
        }
    }
}
