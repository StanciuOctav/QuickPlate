//
//  SignUpView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 17.11.2022.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject private var viewModel = SignUpViewModel()

    @State private var passwordFormatError: Bool = false
    @State private var passwordsDontMatch: Bool = false

    private let maxHeight: CGFloat = 50
    private let toolBarTextFontSize: CGFloat = 20
    private let topLeading: CGFloat = 10

    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    Group {
                        TextField("Nume utilizator", text: $viewModel.username)
                        TextField("Prenume", text: $viewModel.firstName)
                        TextField("Nume", text: $viewModel.lastName)
                    }
                    .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                    Group {
                        Menu {
                            ForEach(viewModel.dropdownRoles, id: \.self) { role in
                                Button(role) {
                                    viewModel.selectedRole = role
                                    _ = resetRestaurantDropDown()
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedRole.isEmpty ? "Tip Cont" : viewModel.selectedRole)
                                    .foregroundColor(viewModel.selectedRole.isEmpty ? nil : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.qpLightGrayColor)
                            .cornerRadius(.infinity)
                        }

                        Menu {
                            ForEach(viewModel.dropdownRestaurants, id: \.self) { restaurant in
                                Button(restaurant) {
                                    viewModel.selectedRestaurant = restaurant
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedRestaurant.isEmpty || viewModel.selectedRole == "Client" ? resetRestaurantDropDown() : viewModel.selectedRestaurant)
                                    .foregroundColor(viewModel.selectedRestaurant.isEmpty ? nil : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.black)
                                    .opacity(viewModel.isRestaurantDisabled ? 0.1 : 1.0)
                            }
                            .padding()
                            .background(Color.qpLightGrayColor)
                            .cornerRadius(.infinity)
                        }.disabled(viewModel.isRestaurantDisabled)
                    }

                    Group {
                        TextField("Email", text: $viewModel.email)
                            .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        SecureInputView("Parola", text: $viewModel.password, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        if self.passwordFormatError {
                            Text("Password must have at least 6 characters")
                                .foregroundColor(.red)
                        } else {
                            EmptyView()
                        }

                        SecureInputView("Confirma Parola", text: $viewModel.confirmPassword, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        if self.passwordsDontMatch {
                            Text("Password don't match").foregroundColor(.red)
                        } else {
                            EmptyView()
                        }
                    }

                    Button(action: {
                        self.passwordFormatError = viewModel.passwordWrongFormat
                        self.passwordsDontMatch = viewModel.passwordsAreDifferent
                    }) {
                        Text("Creeaza un cont nou")
                            .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: self.maxHeight)
                    .background(Color.qpOrange)
                    .cornerRadius(.infinity)
                }
                Spacer()
            }
            .padding()
            .tint(.black)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Creaza un cont nou")
                        .font(.system(size: self.toolBarTextFontSize))
                        .fontWeight(.medium)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text("Inapoi")
                    }
                    .tint(Color.qpOrange)
                }
            }
        }
    }

    private func resetRestaurantDropDown() -> String {
        // This is for the use case when the user selects a restaurant and after that he selectes the Client role
        DispatchQueue.main.async { viewModel.selectedRestaurant = "" }
        return "Restaurant"
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
