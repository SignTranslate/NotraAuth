//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
import SwiftUI

public struct ButtonHelper: View {
    
    var disabled: Bool
    var height: CGFloat
    let label: String
    var color: Color
    var labelColor: Color
    let action: (() -> Void)
    
    public init(disabled: Bool, height: CGFloat = 56, label: String, color: Color = .blue, labelColor: Color = .white, action: @escaping () -> Void) {
        self.disabled = disabled
        self.height = height
        self.label = label
        self.color = color
        self.labelColor = labelColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                TextHelper(text: label, color: labelColor, fontSize: 16)
                Spacer()
            }.frame(width: min(500, UIScreen.main.bounds.size.width * 0.9), height: height)
            .background(color)
                .opacity(disabled ? 0.5 : 1)
                .cornerRadius(16)
        }.disabled(disabled)
    }
}
