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
//                SplashScreenView()
                QPTabView()
//                RestaurantCardView(restaurant: RestaurantCardDTO(id: "312", name: "Marty", picture: "https://lh5.googleusercontent.com/p/AF1QipPt-VVI8HrxYQPRPmy5NIgi3Si4CI4mBp7JtX8s=w408-h544-k-no", address: "Piața Muzeului 2, Cluj-Napoca 400019",openHour: "11:00", closeHour: "23:00", rating: 4.9))
            }
            .environmentObject(userStateViewModel)
        }
    }
}
