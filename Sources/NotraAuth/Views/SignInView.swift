//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var authVM = AuthViewModel()
    @EnvironmentObject var viewRouter: AuthViewRouter
    @Binding var signUp: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TextFieldHelper(type: .textfield, placeholder: "example@example.com", text: $authVM.email)
            
            TextFieldHelper(type: .password, placeholder: "password"~, text: $authVM.password)
            
            ButtonHelper(disabled: !authVM.email.isEmail
                         || authVM.password.count < 6
                         || authVM.loading, label: authVM.loading ? "processing"~ : "signIn"~) {
                
                authVM.signInWithEmail()
            }
            
            HStack (spacing: 2, content: {
                TextHelper(text: "dontHaveAccount"~)
                Button {
                    withAnimation { signUp.toggle() }
                } label: {
                    TextHelper(text: "signUp"~, color: .blue)
                }
                
                Spacer()
                
                Button {
                    // navigate here
                    viewRouter.pushAuthPath(.resetPassword)
                } label: {
                    TextHelper(text: "forgotPassword"~, color: .blue)
                }
            }).frame(width: min(500, UIScreen.main.bounds.size.width * 0.9))
            
            VStack {
                HStack(spacing: 10) {
                    Spacer()
                    GoogleSignIn()
                        .environmentObject(authVM)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    AppleSignIn()
                        .environmentObject(authVM)
                    
                    Spacer()
                }
            }.padding(.top, 40)
        }.padding()
            .alert("error"~, isPresented: $authVM.showAlert, actions: {
                Button("ok"~, role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}

#Preview {
    SignInView(signUp: .constant(false))
        .environmentObject(AuthViewRouter())
}
