//
//  SignUpView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 17.11.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State var selectedRole: String = ""
    var dropdownRoles = ["Client", "Chelner", "Barman", "Bucatar"]
    
    @State var selectedRestaurant: String = ""
    var dropdownRestaurants = ["Marty", "Samsara", "Noir"]
    
    var isRestaurantDisabled: Bool {
        get {
            !(selectedRole != "Client" && !selectedRole.isEmpty)
        }
    }
    
    @State private var isPasswordSecure: Bool = true
    @State private var isConfirmPasswordSecure: Bool = true
    
    private let maxHeight: CGFloat = 50
    private let toolBarTextFontSize: CGFloat = 20
    private let topLeading: CGFloat = 10
    
    
    private func resetRestaurantDropDown() -> String {
        // This is for the use case when the user selects a restaurant and after that he selectes the Client role
        DispatchQueue.main.async { self.selectedRestaurant = "" }
        return "Restaurant"
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    
                    Group {
                        TextField("Nume utilizator", text: $username)
                        TextField("Prenume", text: $firstName)
                        TextField("Nume", text: $lastName)
                    }
                    .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)
                    
                    Group {
                        Menu {
                            ForEach(dropdownRoles, id: \.self) { role in
                                Button(role) {
                                    self.selectedRole = role
                                    _ = resetRestaurantDropDown()
                                }
                            }
                        } label: {
                            HStack{
                                Text(selectedRole.isEmpty ? "Tip Cont" :  selectedRole)
                                    .foregroundColor(selectedRole.isEmpty ? nil : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.qpLightGrayColor)
                            .cornerRadius(.infinity)
                        }
                        
                        Menu {
                            ForEach(dropdownRestaurants, id: \.self) { restaurant in
                                Button(restaurant) {
                                    self.selectedRestaurant = restaurant
                                }
                            }
                        } label: {
                            HStack{
                                Text(selectedRestaurant.isEmpty || selectedRole == "Client" ? resetRestaurantDropDown() : selectedRestaurant)
                                    .foregroundColor(selectedRestaurant.isEmpty ? nil : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.black)
                                    .opacity(isRestaurantDisabled ? 0.1 : 1.0)
                            }
                            .padding()
                            .background(Color.qpLightGrayColor)
                            .cornerRadius(.infinity)
                        }.disabled(isRestaurantDisabled)
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)
                        
                        SecureInputView("Parola", text: $password, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)
                        
                        SecureInputView("Confirma Parola", text: $confirmPassword, maxHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: Color.qpLightGrayColor)
                    }
                    
                    Button(action: {
                        print("Trying to Sign Up")
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
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
