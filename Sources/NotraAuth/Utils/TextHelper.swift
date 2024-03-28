//
//  SwiftUIView.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import SwiftUI

public struct TextHelper: View {
    let text: String
    let color: Color
    let fontSize: CGFloat
    let font: Font
    
    public init(text: String, color: Color = .primary, fontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 12 : 15) {
        self.text = text
        self.color = color
        self.fontSize =  fontSize
        self.font = .system(size: fontSize)
    }
    
    public var body: some View {
        Text(text)
            .foregroundColor(color)
            .dynamicTypeSize(UIDevice.current.userInterfaceIdiom == .phone ? .large : .xxLarge)
            .font(.custom("SF Pro Text", size: fontSize))
            .fixedSize(horizontal: false, vertical: true)
            .kerning(0.3)
    }
}

#Preview {
    TextHelper(text: "Some text here")
}
