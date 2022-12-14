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

    var body: some View {
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

                    Button {
                        viewModel.signIn { result in
                            switch result {
                            case .success(_):
                                viewModel.setShowCredentialsErrors(withBool: false)
                                userStateViewModel.signIn()
                            case .failure(.signInError):
                                viewModel.setShowCredentialsErrors(withBool: true)
                            case .failure(.anonymousUser), .failure(_):
                                break
                            }
                        }
                    } label: {
                        Text(LocalizedStringKey("signin"))
                            .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                    .background(Color.qpOrange)
                    .cornerRadius(.infinity)

                    Text(LocalizedStringKey("or"))
                        .frame(maxWidth: .infinity)

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
