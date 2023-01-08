//
//  TabView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct QPTabView: View {
    var body: some View {
        TabView {
            Group {
                RestaurantsListView()
                    .tabItem {
                        Label(LocalizedStringKey("restaurants"), systemImage: "fork.knife.circle")
                    }
                
                MapView()
                    .tabItem {
                        Label(LocalizedStringKey("map"), systemImage: "map.fill")
                    }

                UserProfileView()
                    .tabItem {
                        Label(LocalizedStringKey("account"), systemImage: "person.fill")
                    }
            }.accentColor(.accentColor)
        }.accentColor(Color.qpOrange)
    }
}
