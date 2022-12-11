//
//  SecureInputView.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 20.11.2022.
//

import SwiftUI

struct SecureInputView: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String

    private var maxHeight: CGFloat
    private var backgroundColor: Color
    private var topLeading: CGFloat

    init(_ title: String, text: Binding<String>, maxHeight: CGFloat, topLeading: CGFloat, backgroundColor: Color) {
        self.title = title
        _text = text
        self.backgroundColor = backgroundColor
        self.topLeading = topLeading
        self.maxHeight = maxHeight
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            if isSecured {
                SecureField(title, text: $text)
                    .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: self.backgroundColor)
            } else {
                TextField(title, text: $text)
                    .signInTextFieldStyle(withHeight: self.maxHeight, topLeading: self.topLeading, backgroundColor: self.backgroundColor)
            }

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash.fill" : "eye.fill")
            }.padding(.trailing, 10)
        }
        .tint(.black)
    }
}
