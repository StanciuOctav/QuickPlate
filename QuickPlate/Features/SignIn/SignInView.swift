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

    @StateObject var viewModel = SignInViewModel()
    @ObservedObject var loginManager: LoginManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // MARK: HEADER

                    Image("app-icon")
                    Text(LocalizedStringKey("welcome"))
                        .fontWeight(.medium)
                        .font(.system(size: self.fontSize))
                    Text(LocalizedStringKey("signin-message"))
                        .multilineTextAlignment(.center)
                        .padding()

                    // MARK: BODY

                    VStack(spacing: 30) {
                        TextField(LocalizedStringKey("email"), text: $viewModel.email)
                            .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)
                        SecureInputView(LocalizedStringKey("password").stringValue(), text: $viewModel.password, maxHeight: self.maxHeight, topLeading: 10, backgroundColor: Color.qpLightGrayColor)

                        if viewModel.getShowCredentialsError() {
                            // FIXME: This remains if the user doesn't insert the right credentials AND comes back from the Sign Up Page
                            Text(LocalizedStringKey("credentials-error"))
                                .foregroundColor(.red)
                        } else {
                            EmptyView()
                        }

                        SignInButton()

                        Text(LocalizedStringKey("or"))
                            .frame(maxWidth: .infinity)

                        CreateAccountButton()
                    }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func SignInButton() -> some View {
        Button {
            viewModel.signIn { result in
                switch result {
                case .success:
                    loginManager.updateWith(state: .clientSignedIn)
                case .failure(.signInError):
                    viewModel.setShowCredentialsErrors(withBool: true)
                case .failure(.anonymousUser), .failure:
                    break
                }
            }
        } label: {
            Text(LocalizedStringKey("signin"))
                .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                .padding(.horizontal, 10)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
        .background(Color.qpOrange)
        .cornerRadius(.infinity)
    }

    @ViewBuilder
    func CreateAccountButton() -> some View {
        Button {
            viewModel.setShowCredentialsErrors(withBool: false)
            print("Trying to Sign Up")
        } label: {
            NavigationLink {
                SignUpView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text(LocalizedStringKey("signup"))
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                    .foregroundColor(Color.qpOrange)
                    .overlay(
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.qpOrange, lineWidth: self.roundedRectangleLineWidth)
                            .padding(.horizontal, 10)
                    )
            }
        }
    }
}
