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
                MapView()
                    .tabItem {
                        Label(LocalizedStringKey("map"), systemImage: "map.fill")
                    }

                RestaurantsListView()
                    .tabItem {
                        Label(LocalizedStringKey("restaurants"), systemImage: "fork.knife.circle")
                    }

                UserProfileView()
                    .tabItem {
                        Label(LocalizedStringKey("account"), systemImage: "person.fill")
                            .foregroundColor(.black)
                    }
            }.accentColor(.accentColor)
        }.accentColor(Color.qpOrange)
    }
}
