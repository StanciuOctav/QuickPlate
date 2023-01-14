//
//  TabView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct QPTabView: View {
    @ObservedObject var loginManager: LoginManager
    var body: some View {
        TabView {
            Group {
                MapView()
                    .tabItem {
                        Label(LocalizedStringKey("map"), systemImage: "map.fill")
                    }
                
                RestaurantsListView()
                    .tabItem {
                        Label(LocalizedStringKey("restaurants"), systemImage: "fork.knife.circle")
                    }

                UserProfileView(loginManager: loginManager)
                    .tabItem {
                        Label(LocalizedStringKey("account"), systemImage: "person.fill")
                    }
            }.accentColor(.accentColor)
        }.accentColor(Color.qpOrange)
    }
}
