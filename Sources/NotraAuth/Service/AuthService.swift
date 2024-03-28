//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
import FirebaseAuth
import CryptoKit
import SwiftUI
import GoogleSignIn
import FirebaseCore
import AuthenticationServices


public protocol AuthServiceProtocol {
    func signOut() async -> Result<Void, Error>
    func deleteAccount() async -> Result<Void, Error>
    
    func signIn(email: String, password: String) async -> Result<Void, Error>
    func signUp(email: String, password: String) async -> Result<Void, Error>
    func sendRecoveryEmail(email: String) async -> Result<Void, Error>
    // google sign in
    func authenticateWithGoogle(viewController: UIViewController) async -> Result<Void, Error>
    
    // apple sign in
    func randomNonceString(length: Int) -> String
    func sha256(_ input: String) -> String
    func authenticateWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async -> Result<Void, Error>
}


public class AuthService {
    public static let shared: AuthServiceProtocol = AuthService()
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    public func deleteAccount() async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Auth.auth().currentUser?.delete()
        }
    }
    
    
    public func signIn(email: String, password: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
    }
    
    public func sendRecoveryEmail(email: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
    }
    
    public func signUp(email: String, password: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }
    
    
    public func signOut() async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try Auth.auth().signOut()
        }
    }
    
    public func authenticateWithGoogle(viewController: UIViewController) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw NSError(domain: "Error",
                              code: 0,
                              userInfo: [NSLocalizedDescriptionKey: "Error initializing firebase"])
            }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            guard let token = result.user.idToken?.tokenString else {
                throw NSError(domain: "Error",
                              code: 0,
                              userInfo: [NSLocalizedDescriptionKey: "Could not get user token"])

            }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: token, accessToken: result.user.accessToken.tokenString)
            try await Auth.auth().signIn(with: credentials)
            
        }
    }
    
    public func authenticateWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async -> Result<Void, Error> {
        
        return await APIHelper.shared.voidRequest {
            if let token = credential.identityToken,
               let tokenString = String(data: token, encoding: .utf8) {
                let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)

                try await Auth.auth().signIn(with: firebaseCredential)
            } else {
                throw NSError(domain: "Error",
                              code: 0,
                              userInfo: [NSLocalizedDescriptionKey: "Something went wrong."])
            }
        }
    }
    
    public func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    public func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
