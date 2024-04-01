//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 01.04.24.
//

import Foundation
import SwiftUI
import AuthenticationServices
@testable import NotraAuth

class MockAuthService: AuthServiceProtocol {
    var signOutError: Bool = false
    var signInError: Bool = false
    var signUpError: Bool = false
    var sendRecoveryEmailError: Bool = false
    var authenticateWithGoogleError: Bool = false
    var authenticateWithAppleError: Bool = false
    var deleteAccountError = false
    
    func deleteAccount() async -> Result<Void, Error> {
        if deleteAccountError {
            return .failure(CustomErrors.createErrorWithMessage("Error deleting account"))
        } else {
            return .success(())
        }
    }
    
    func signOut() async -> Result<Void, Error> {
        if signOutError {
            return .failure(CustomErrors.createErrorWithMessage("Error signing out"))
        } else {
            return .success(())
        }
    }
    
    func signIn(email: String, password: String) async -> Result<Void, Error> {
        if signInError {
            return .failure(CustomErrors.createErrorWithMessage("Error signing in"))
        } else {
            return .success(())
        }
    }
    
    func signUp(email: String, password: String) async -> Result<Void, Error> {
        if signUpError {
            return .failure(CustomErrors.createErrorWithMessage("Error signing up"))
        } else {
            return .success(())
        }
    }
    
    func sendRecoveryEmail(email: String) async -> Result<Void, Error> {
        if sendRecoveryEmailError {
            return .failure(CustomErrors.createErrorWithMessage("Error sending recovery email"))
        } else {
            return .success(())
        }
    }
    
    func authenticateWithGoogle(viewController: UIViewController) async -> Result<Void, Error> {
        if authenticateWithGoogleError {
            return .failure(CustomErrors.createErrorWithMessage("Failed to authenticate with google"))
        } else {
            return .success(())
        }
    }
    
    func authenticateWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async -> Result<Void, Error> {
        if authenticateWithAppleError {
            return .failure(CustomErrors.createErrorWithMessage("Failed to authenticate with apple"))
        } else {
            return .success(())
        }
    }
    
    func randomNonceString(length: Int) -> String {
        return ""
    }
    
    func sha256(_ input: String) -> String {
        return ""
    }
}
