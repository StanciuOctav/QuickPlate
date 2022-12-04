//
//  UserProfileView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 21.11.2022.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject var vm = UserProfileViewModel()
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    
    var body: some View {
            Button {
                vm.signOut(completion: { didNotSignOut in
                    if didNotSignOut != nil {
                        print("UserProfileView - The user couldn't sign out")
                    } else {
                        print("Did the user sign out? \(didNotSignOut != nil ? "NO" : "YES")")
                        userStateViewModel.signOut()
                    }
                })
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
