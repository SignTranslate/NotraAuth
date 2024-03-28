//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import AuthenticationServices
import DataCache

public class AuthViewModel: AlertViewModel, ObservableObject {
    @Published public var loading: Bool = false
    @Published public var showAlert: Bool = false
    @Published public var alertMessage: String = ""
    
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""
    
    @Published var nonce = ""

        
    var manager: AuthServiceProtocol
    public init(manager: AuthServiceProtocol = AuthService.shared) {
        self.manager = manager
    }
    
    public var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    public func listenToAuthState() {
        loading = true
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
            self.loading = false
        }
    }
    
    @MainActor public func signUpWithEmail() {
        loading = true
        Task {
            
            let result = await manager.signUp(email: email, password: password)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                print("successful sign up")
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor public func signInWithEmail() {
        loading = true
        Task {
            
            let result = await manager.signIn(email: email, password: password)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                print("successful sign in")
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor public func signOut() {
        loading = true

        Task {
            let result = await manager.signOut()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                print("signed out do somethig here")
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor public func googleSignin(viewController: UIViewController) {
         
         loading = true
         Task {
             
             let result = await manager.authenticateWithGoogle(viewController: viewController)
             switch result {
             case .failure(let error):
                 self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
             case .success(()):
                 print("authenticatedd with google")
             }
             if !Task.isCancelled {
                 loading = false
             }
         }
     }
    
    @MainActor public func appleSignin(credential: ASAuthorizationAppleIDCredential) {
        loading = true
        Task {
            let result = await manager.authenticateWithApple(credential: credential, nonce: nonce)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                print("Authenticated with apple")
            }
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor public func sendPasswordResetEmail(action: @escaping () -> ()) {
        loading = true
        Task {
            let result = await manager.sendRecoveryEmail(email: email)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                action()
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor public func deleteAccount() {
        loading = true
        
        Task {
            let result = await manager.deleteAccount()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                DataCache.instance.cleanAll()
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    public func setupNonce() {
        nonce = manager.randomNonceString(length: 32)
    }
    
    public func setupSha() -> String {
        return manager.sha256(self.nonce)
    }
}
