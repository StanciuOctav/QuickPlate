//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct UserProfileView: View {
    
    @State var userSignOut: Bool = false
    
    var body: some View {
        if (userSignOut) {
            SignInView()
        } else {
            Button {
                userSignOut.toggle()
            } label: {
                Text("Sign Out from app")
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
