//
//  TabView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct QPTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.qpDarkGrayColor)
        UITabBar.appearance().backgroundColor = .white
    }

    var body: some View {
        TabView {
            Group {
                UserProfileView()
                    .tabItem {
                        Label(LocalizedStringKey("account"), systemImage: "person.fill")
                    }
                
                RestaurantsListView()
                    .tabItem {
                        Label(LocalizedStringKey("restaurants"), systemImage: "fork.knife.circle")
                    }
                
                MapView()
                    .tabItem {
                        Label(LocalizedStringKey("map"), systemImage: "map.fill")
                    }
            }
            .tint(.qpBlackColor)
        }
        .tint(Color.qpOrange)
    }
}