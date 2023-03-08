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
                
                NavigationView {
                    UserProfileView(loginManager: loginManager)
                }
                .tabItem {
                    Label(LocalizedStringKey("account"), systemImage: "person.fill")
                }
                
                NavigationView {
                    RestaurantsListView()
                }
                .tabItem {
                    Label(LocalizedStringKey("restaurants"), systemImage: "fork.knife.circle")
                }

                MapView()
                    .tabItem {
                        Label(LocalizedStringKey("map"), systemImage: "map.fill")
                    }
            }
        }
        .tint(Color.qpOrange)
    }
}
