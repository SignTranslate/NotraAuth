//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI
import AuthenticationServices

struct AppleSignIn: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        SignInWithAppleButton { request in
            authVM.setupNonce()
            request.requestedScopes = [.email, .fullName]
            request.nonce = authVM.setupSha()
        } onCompletion: { result in
            switch result {
            case .success(let user):
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                    print("error with firebase")
                    return
                }
                
                authVM.appleSignin(credential: credential)
            case .failure(let error):
                authVM.makeAlert(with: error, message: &authVM.alertMessage, alert: &authVM.showAlert)
                print(error.localizedDescription)
            }
        }.frame(width: min(400, UIScreen.main.bounds.size.width * 0.65 ), height: 47)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        

    }
}

#Preview {
    AppleSignIn()
        .environmentObject(AuthViewModel())
}
