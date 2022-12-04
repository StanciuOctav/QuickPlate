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
                        Label("Harta", systemImage: "map.fill")
                    }
                    .accentColor(.accentColor)
                
                RestaurantsListView()
                    .tabItem {
                        Label("Restaurante", systemImage: "fork.knife.circle")
                    }
                
                UserProfileView()
                    .tabItem {
                        Label("Cont", systemImage: "person.fill")
                            .foregroundColor(.black)
                    }
            }.accentColor(.accentColor)
        }.accentColor(Color.qpOrange)
    }
}

//struct QPTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        QPTabView()
//    }
//}
