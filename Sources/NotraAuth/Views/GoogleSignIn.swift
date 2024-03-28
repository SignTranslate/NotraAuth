//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

struct GoogleSignIn: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Button {
             authVM.googleSignin(viewController: getRootViewController())
         } label: {
             HStack(spacing: 10) {
                 Image("google_logo", bundle: .module)
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 24, height: 24)
                     .foregroundColor(.black)
                 
                 TextHelper(text: "signInWithGoogle"~, color: .primary, fontSize: 16)
                     .fontWeight(.semibold)

             }.frame(width: min(400, UIScreen.main.bounds.size.width * 0.65 ), height: 47)
             .background(RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.gray, lineWidth: 2))
         }
    }
}

#Preview {
    GoogleSignIn()
        .environmentObject(AuthViewModel())
}
