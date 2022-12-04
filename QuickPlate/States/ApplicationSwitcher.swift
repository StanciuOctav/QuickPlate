//
//  ApplicationSwitcher.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import SwiftUI

struct ApplicationSwitcher: View {
    
    @EnvironmentObject var vm: UserStateViewModel
    
    var body: some View {
        if (vm.isLoggedIn) {
            QPTabView()
        } else {
            SignInView()
        }
    }
}

struct ApplicationSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationSwitcher()
    }
}
