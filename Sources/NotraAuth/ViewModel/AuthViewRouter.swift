//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
import SwiftUI

class AuthViewRouter: AlertViewModel, ObservableObject {
    @Published var authPath = [AuthViewPaths]()
    
    @Published var tab: Int = 0
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func pushAuthPath(_ page: AuthViewPaths)        { authPath.append(page) }
    func popAuthPath()                              { authPath.removeLast() }
    func popToAuthRoot()                            { authPath.removeLast(authPath.count) }

    @ViewBuilder
    func buildAuthView(page: AuthViewPaths) -> some View {
        switch page {
        case .resetPassword:
            ResetPassword()
        }
    }
}
