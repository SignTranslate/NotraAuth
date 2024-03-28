//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var authVM = AuthViewModel()
    @Binding var signUp: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            TextFieldHelper(type: .textfield, placeholder: "example@example.com", text: $authVM.email)
            
            TextFieldHelper(type: .password, placeholder: "password"~, text: $authVM.password)
            
            TextFieldHelper(type: .password, placeholder: "passwordConfirm"~, text: $authVM.confirmPassword)
            
            ButtonHelper(disabled: !authVM.email.isEmail
                         || authVM.password.count < 6
                         || (authVM.password.count >= 6 && authVM.password != authVM.confirmPassword)
                         || authVM.loading, label: authVM.loading ? "processing"~ : "signUp"~) {
                authVM.signUpWithEmail()
            }.padding(.top, 50)
            
            HStack (spacing: 2, content: {
                TextHelper(text: "alreadyHaveAccount"~)
                Button {
                    withAnimation { signUp.toggle() }
                } label: {
                    TextHelper(text: "signIn"~, color: .blue)
                }
                
            })
            
        }.padding()
            .alert("error"~, isPresented: $authVM.showAlert, actions: {
                Button("ok"~, role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}

#Preview {
    SignUpView(signUp: .constant(false))
}
