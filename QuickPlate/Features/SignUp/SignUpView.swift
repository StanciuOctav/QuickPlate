//
//  SignUpView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 17.11.2022.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var vm = SignUpViewModel()
    
    @State private var passwordFormatError: Bool = false
    @State private var passwordsDontMatch: Bool = false
    @State private var successSignUp: Bool = false
    @State private var fieldsIncompleted: Bool = false
    @State private var emailExists: Bool = false
    
    @State private var selectedRole: String = ""
    @State private var selectedRestaurant: String = ""
    
    var isRestaurantDisabled: Bool {
        !(selectedRole != "Client" && !selectedRole.isEmpty)
    }
    
    private let maxHeight: CGFloat = 50
    private let toolBarTextFontSize: CGFloat = 20
    private let topInset: CGFloat = 10
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    Group {
                        TextField(LocalizedStringKey("username"), text: $vm.username)
                        TextField(LocalizedStringKey("firstName"), text: $vm.firstName)
                        TextField(LocalizedStringKey("lastName"), text: $vm.lastName)
                    }
                    .signInTextFieldStyle(withHeight: self.maxHeight, topInset: self.topInset, backgroundColor: Color.qpLightGrayColor)
                    
                    Group {
                        Menu {
                            ForEach(vm.dropdownRoles, id: \.self) { role in
                                Button(role) {
                                    self.selectedRole = role
                                    _ = resetRestaurantDropDown()
                                }
                            }
                        } label: {
                            HStack {
                                Text(self.selectedRole == "" ? LocalizedStringKey("accountType").stringValue() : self.selectedRole)
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
                            ForEach(vm.restaurants) { restaurant in
                                Button(restaurant.name) {
                                    vm.setRestaurantId(withId: restaurant.id ?? "")
                                    self.selectedRestaurant = restaurant.name
                                }
                            }
                        } label: {
                            HStack {
                                Text(self.selectedRestaurant == "" || self.selectedRole == LocalizedStringKey("client").stringValue() ? resetRestaurantDropDown() : self.selectedRestaurant)
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
                        TextField(LocalizedStringKey("email"), text: $vm.email)
                            .signInTextFieldStyle(withHeight: self.maxHeight, topInset: self.topInset, backgroundColor: Color.qpLightGrayColor)
                            .keyboardType(.emailAddress)
                        
                        SecureInputView(LocalizedStringKey("password").stringValue(), text: $vm.password, maxHeight: self.maxHeight, topInset: self.topInset, backgroundColor: Color.qpLightGrayColor)
                        
                        SecureInputView(LocalizedStringKey("confirm-password").stringValue(), text: $vm.confirmPassword, maxHeight: self.maxHeight, topInset: self.topInset, backgroundColor: Color.qpLightGrayColor)
                        
                        if self.passwordFormatError && !self.fieldsIncompleted {
                            Text(LocalizedStringKey("password-format-error"))
                                .foregroundColor(.red)
                        } else {
                            EmptyView()
                        }
                        if self.passwordsDontMatch && !self.fieldsIncompleted {
                            Text(LocalizedStringKey("passwords-match-error")).foregroundColor(.red)
                        } else {
                            EmptyView()
                        }
                    }
                    
                    Button {
                        self.fieldsIncompleted = vm.allFieldsAreCompleted() && selectedRole != "" ? false : true
                        
                        if self.fieldsIncompleted == false {
                            self.passwordFormatError = vm.passwordWrongFormat
                            self.passwordsDontMatch = vm.passwordsAreDifferent
                        }
                        
                        if !self.fieldsIncompleted && !self.passwordFormatError && !self.passwordsDontMatch {
                            vm.doSignUp(withRole: self.selectedRole) { result in
                                switch result {
                                case .success:
                                    successSignUp = true
                                case .failure:
                                    emailExists = true
                                }
                            }
                        }
                    } label: {
                        Text(LocalizedStringKey("signup"))
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
                    Text(LocalizedStringKey("signup"))
                        .font(.system(size: self.toolBarTextFontSize))
                        .fontWeight(.medium)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text(LocalizedStringKey("back"))
                    }
                    .tint(Color.qpOrange)
                }
            }
        }
        .task {
            await vm.fetchAllRestaurants()
        }
        .alert(LocalizedStringKey("created-account-message"), isPresented: $successSignUp) {
            Button(LocalizedStringKey("back-to-signin")) {
                successSignUp = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(LocalizedStringKey("complete-all-fields-message"), isPresented: $fieldsIncompleted) {
            Button("OK", role: .cancel) { }
        }
        .alert(LocalizedStringKey("signup-email-exists-error"), isPresented: $emailExists) {
            Button("OK", role: .cancel) { }
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
