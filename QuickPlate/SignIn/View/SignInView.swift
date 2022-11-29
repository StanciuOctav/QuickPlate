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
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var signIn: Bool = false
    @State private var signUp: Bool = false
    
    var body: some View {
        if signIn {
            QPTabView()
        } else {
            NavigationView {
                ScrollView {
                    VStack {
                        // MARK: HEADER
                        Image("app-icon")
                        Text("Bine ai venit!")
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        Text("Intra in cont pentru a putea rezerva o masa la un restaurant si pentru a seta o precomanda.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // MARK: BODY
                        VStack(spacing: 30) {
                            TextField("Nume utilizator", text: $username)
                                .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)
                            SecureInputView("Parola", text: $password, maxHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)
                            
                            
                            
                            Button(action: {
                                //if username != "" && password != "" {
                                signIn.toggle()
                                //}
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
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
