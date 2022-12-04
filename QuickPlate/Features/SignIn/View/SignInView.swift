//
//  ContentView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 13.11.2022.
//

import SwiftUI

struct SignInView: View {
    
    private let maxHeight: CGFloat = 50
    private let roundedRectangleLineWidth: CGFloat = 3
    private let fontSize: CGFloat = 20
    
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    @StateObject var viewModel = SignInViewModel()
    
    @State var showCredentialsErrors: Bool = false
    
    @State private var signUp: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                // MARK: HEADER
                Image("app-icon")
                Text("Bine ai venit!")
                    .fontWeight(.medium)
                    .font(.system(size: self.fontSize))
                Text("Intra in cont pentru a putea rezerva o masa la un restaurant si pentru a seta o precomanda.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                // MARK: BODY
                VStack(spacing: 30) {
                    TextField("Email", text: $viewModel.email)
                        .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)
                    SecureInputView("Parola", text: $viewModel.password, maxHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)
                    
                    Text("Credentiale gresite / Cont inexistent")
                        .foregroundColor(.red)
                        .hidden(!self.showCredentialsErrors)
                        
                    Button(action: {
                        viewModel.signIn { didNotSignIn in
                            if didNotSignIn != nil {
                                self.showCredentialsErrors = true
                            } else {
                                print("Did the user sign in? \(didNotSignIn != nil ? "NO" : "YES")")
                                self.showCredentialsErrors = false
                                userStateViewModel.signIn()
                            }
                        }
                    }) {
                        Text("Intra in cont")
                            .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                    .background(Color.qpOrange)
                    .cornerRadius(.infinity)
                    
                    
                    Text("sau")
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        signUp.toggle()
                        print("Trying to Sign Up")
                    } label: {
                        NavigationLink {
                            SignUpView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Creeaza un cont nou")
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                                .foregroundColor(Color.qpOrange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .stroke(Color.qpOrange, lineWidth: self.roundedRectangleLineWidth)
                                )
                        }
                    }
                }
            }
            .padding()
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
