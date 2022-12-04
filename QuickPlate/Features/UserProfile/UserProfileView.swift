//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    
    var body: some View {
            Button {
                userStateViewModel.signOut()
            } label: {
                Text("Sign Out from app")
            }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
