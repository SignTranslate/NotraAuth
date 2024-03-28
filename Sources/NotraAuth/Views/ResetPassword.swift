//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI
import AlertToast

struct ResetPassword: View {
    @StateObject private var authVM = AuthViewModel()
    @EnvironmentObject var viewRouter: AuthViewRouter
    @State private var showToast: Bool = false
    
    var body: some View {
        VStack( alignment: .leading, spacing: 72) {
            
            VStack(alignment: .leading, spacing: 16) {
                TextHelper(text: "enterYourEmail"~, fontSize: 28)
                    .fontWeight(.semibold)
                
                TextHelper(text: "enterYourEmailToVerifyIdentity"~, fontSize: 17)
            }
            
            TextFieldHelper(type: .textfield, placeholder: "email"~, text: $authVM.email)
            
            Spacer()
            
            ButtonHelper(disabled: !authVM.email.isEmail || authVM.loading,
                         label: "continue"~) {
                authVM.sendPasswordResetEmail {
                    showToast.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        viewRouter.popAuthPath()
                    })
                }
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        ).padding()
            .alert("error"~, isPresented: $authVM.showAlert, actions: {
                Button("ok"~, role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            }).toast(isPresenting: $showToast, duration: 1.7) {
                AlertToast(type: .complete(.green),
                           title: nil,
                           subTitle: "recoverEmailSent"~)
            }
    }
}

#Preview {
    ResetPassword()
}
