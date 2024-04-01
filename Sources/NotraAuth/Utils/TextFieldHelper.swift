//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

public struct TextFieldHelper: View {
    @State private var showPassword: Bool = false
    let type: TextFieldHelperStyle
    let placeholder: String
    let keyboard: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization?
    @Binding var text: String
    let dynamicSize: DynamicTypeSize
    
    public init(type: TextFieldHelperStyle,
         placeholder: String,
         keyboard: UIKeyboardType = .emailAddress,
         autocapitalization: TextInputAutocapitalization? = .never,
         text: Binding<String>) {
        self.type = type
        self.placeholder = placeholder
        self.keyboard = keyboard
        self.autocapitalization = autocapitalization
        self._text = text
        self.dynamicSize = UIDevice.current.userInterfaceIdiom == .phone ? .large : .xxLarge
    }
    
    public var body: some View {
        switch type {
        case .password:
            VStack(spacing: 0) {
                HStack {
                    if showPassword {
                        TextField(placeholder, text: $text)
                            .dynamicTypeSize(dynamicSize)
                            .textContentType(.password)
                            .textInputAutocapitalization(autocapitalization)
                            .frame(height: 25)
                    } else {
                        SecureField(placeholder, text: $text)
                            .dynamicTypeSize(dynamicSize)
                            .textContentType(.password)
                            .frame(height: 25)
                    }
                    
                    Spacer()
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .dynamicTypeSize(dynamicSize)
                            .tint(.primary)
                    }
                    
                }.padding([.top, .trailing])
                    .padding(.bottom, 8)
                
                Divider()
            }.frame(width: min(500, UIScreen.main.bounds.width * 0.9))
            
        case .textfield:
            VStack(spacing: 0) {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(autocapitalization)
                    .dynamicTypeSize(dynamicSize)
                    .keyboardType(keyboard)
                    .padding([.top, .trailing])
                        .padding(.bottom, 8)
                    
                    Divider()
            }.frame(width: min(500, UIScreen.main.bounds.width * 0.9))
        }
    }
}

#Preview {
    TextFieldHelper(type: .password, placeholder: "password", keyboard: .emailAddress, text: .constant(""))
}
