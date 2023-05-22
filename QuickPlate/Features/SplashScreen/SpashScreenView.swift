//
//  SpashScreenView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 13.11.2022.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var showing: Bool
    
    var body: some View {
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
                    self.showing = false
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(showing: .constant(true))
    }
}
