//
//  AuthViewModelTests.swift
//  
//
//  Created by Karen Mirakyan on 01.04.24.
//

import XCTest
@testable import NotraAuth
import AuthenticationServices

final class AuthViewModelTests: XCTestCase {

    var service: MockAuthService!
    var viewModel: AuthViewModel!
    
    override func setUp() {
        self.service = MockAuthService()
        self.viewModel = AuthViewModel(manager: self.service)
    }
    
    func testSignUpWithError() async {
        service.signUpError = true
        await wait(for: { await self.viewModel.signUpWithEmail()})
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error signing up")
    }
    
    func testSignUpWithSuccess() async {
        service.signUpError = false
        await wait(for: { await self.viewModel.signUpWithEmail() })
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }

    func testSignInWithError() async {
        service.signInError = true
        await wait(for: { await self.viewModel.signInWithEmail() })
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error signing in")
    }
    
    func testSignInWithSuccess() async {
        service.signInError = false
        await wait(for: { await self.viewModel.signInWithEmail() })
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testSignOutWithError() async {
        service.signOutError = true
        await wait(for: { await self.viewModel.signOut()} )
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error signing out")
    }
    
    func testSignOutWithSuccess() async {
        service.signOutError = false
        await wait(for: { await self.viewModel.signOut()} )

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testSendRecoveryEmailWithError() async {
        service.sendRecoveryEmailError = true
        await wait(for: { await self.viewModel.sendPasswordResetEmail { }} )
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error sending recovery email")
    }
    
    func testSendRecoveryEmailWithSuccess() async {
        service.sendRecoveryEmailError = false
        await wait(for: { await self.viewModel.sendPasswordResetEmail { }} )
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testSignInWithGoogleWithError() async {
        service.authenticateWithGoogleError = true
        let mockViewController = await UIViewController(nibName: nil, bundle: nil)

        await wait(for: { await self.viewModel.googleSignin(viewController: mockViewController )} )
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Failed to authenticate with google")
    }
    
    func testSignInWithGoogleWithSuccess() async {
        service.authenticateWithGoogleError = false
        let mockViewController = await UIViewController(nibName: nil, bundle: nil)
        await wait(for: { await self.viewModel.googleSignin(viewController: mockViewController) } )

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testDeleteAccountWithError() async {
        service.deleteAccountError = true
        await wait(for: { await self.viewModel.deleteAccount() })
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error deleting account")
    }
    
    func testDeleteAccountWithSuccess() async {
        service.deleteAccountError = false
        await wait( for: { await self.viewModel.deleteAccount() })
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}

extension XCTestCase {
    @MainActor func wait(for task: @escaping @Sendable () async throws -> Void, timeout: TimeInterval = 5) async {
        let expectation = XCTestExpectation(description: "Async task completion")
        
        Task {
            do {
                try await task()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
}
