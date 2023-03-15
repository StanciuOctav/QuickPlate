//
//  QuickPlateApp.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 13.11.2022.
//

import FirebaseCore
import SwiftUI

@main
struct QuickPlateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
