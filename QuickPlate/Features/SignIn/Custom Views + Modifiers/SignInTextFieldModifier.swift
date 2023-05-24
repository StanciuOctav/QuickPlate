//
//  CustomTextField.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 18.11.2022.
//

import SwiftUI

struct SignInCustomTextField: ViewModifier {
    var height: CGFloat
    var topInset: CGFloat
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 0, leading: topInset, bottom: 0, trailing: 0))
            .frame(height: height)
            .background(backgroundColor)
            .cornerRadius(.infinity)
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func signInTextFieldStyle(withHeight height: CGFloat, topInset inset: CGFloat, backgroundColor color: Color) -> some View {
        modifier(SignInCustomTextField(height: height, topInset: inset, backgroundColor: color))
    }
}
