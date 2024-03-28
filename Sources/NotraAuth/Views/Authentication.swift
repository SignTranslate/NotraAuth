//
//  Authenticate.swift
//
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

struct Authentication: View {
    @EnvironmentObject var viewRouter: AuthViewRouter
    @State private var signUp: Bool = false
    
    var body: some View {
        NavigationStack(path: $viewRouter.authPath) {
            Group {
                if signUp {
                    SignUpView(signUp: $signUp)
                } else {
                    SignInView(signUp: $signUp)
                }
            }.navigationDestination(for: AuthViewPaths.self) { page in
                viewRouter.buildAuthView(page: page)
            }
        }
    }
}

#Preview {
    Authentication()
        .environmentObject(AuthViewRouter())
        .environment(\.locale, .init(identifier: "ru"))

}
