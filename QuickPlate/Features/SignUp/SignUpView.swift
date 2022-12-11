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
    @State private var successSignUp: Bool = false
    @State private var fieldsIncompleted: Bool = false
    
    @State private var selectedRole: String = ""
    @State private var selectedRestaurant: String = ""
    
    var isRestaurantDisabled: Bool {
        !(self.selectedRole != "Client" && !self.selectedRole.isEmpty)
    }

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
                                    self.selectedRole = role
                                    _ = resetRestaurantDropDown()
                                }
                            }
                        } label: {
                            HStack {
                                Text(self.selectedRole == "" ? "Tip Cont" : self.selectedRole)
                                    .foregroundColor(self.selectedRole == "" ? nil : .black)
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
                                    self.selectedRestaurant = restaurant
                                }
                            }
                        } label: {
                            HStack {
                                Text(self.selectedRestaurant == "" || self.selectedRole == "Client" ? resetRestaurantDropDown() : self.selectedRestaurant)
                                    .foregroundColor(self.selectedRestaurant.isEmpty ? nil : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.black)
                                    .opacity(self.isRestaurantDisabled ? 0.1 : 1.0)
                            }
                            .padding()
                            .background(Color.qpLightGrayColor)
                            .cornerRadius(.infinity)
                        }.disabled(self.isRestaurantDisabled)
                    }

                    Group {
                        TextField("Email", text: $viewModel.email)
                            .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        SecureInputView("Parola", text: $viewModel.password, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        SecureInputView("Confirma Parola", text: $viewModel.confirmPassword, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)

                        if self.passwordFormatError && !self.fieldsIncompleted {
                            Text("Parola trebuie sa aiba cel putin 6 caractere!")
                                .foregroundColor(.red)
                        } else {
                            EmptyView()
                        }
                        if self.passwordsDontMatch && !self.fieldsIncompleted {
                            Text("Parolele difera!").foregroundColor(.red)
                        } else {
                            EmptyView()
                        }
                    }

                    Button(action: {
                        self.fieldsIncompleted = viewModel.allFieldsAreCompleted() && selectedRole != "" ? false : true
                        
                        if (self.fieldsIncompleted == false) {
                            self.passwordFormatError = viewModel.passwordWrongFormat
                            self.passwordsDontMatch = viewModel.passwordsAreDifferent
                        }

                        if !self.fieldsIncompleted && !self.passwordFormatError && !self.passwordsDontMatch {
                            viewModel.doSignUp(withRole: self.selectedRole, andRestaurant: self.selectedRestaurant)
                            successSignUp = true
                        }
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
        .alert("Ti-ai creat un cont cu succes!", isPresented: $successSignUp) {
            Button("Inapoi la logare") {
                successSignUp = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .alert("Completeaza toate campurile inainte de a-ti face cont!", isPresented: $fieldsIncompleted) {
            Button("OK", role: .cancel) {
                
            }
        }
    }

    private func resetRestaurantDropDown() -> String {
        // This is for the use case when the user selects a restaurant and after that he selects the Client role
        DispatchQueue.main.async { self.selectedRestaurant = "" }
        return "Restaurant"
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
