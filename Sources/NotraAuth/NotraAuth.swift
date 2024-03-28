// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import AlertToast

public struct NotraAuth: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var viewRouter = AuthViewRouter()
    
    public init() { }
    
    public var body: some View {
        Authentication()
            .environmentObject(viewRouter)
    }
}

#Preview {
    NotraAuth()
}
