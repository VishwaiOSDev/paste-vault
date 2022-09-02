//
//  HoverButton.swift
//  PasteVault
//
//  Created by Vishweshwaran on 25/07/22.
//

import SwiftUI

struct HoverButton: View {
    
    @EnvironmentObject var themeSwitcher: ThemeSwitcher
    @Binding var hoverOn: Bool
    
    var text: String
    var fontSize: CGFloat
    var bgColor: Color
    var hoverColor: Color
    var cornerRadius: CGFloat
    
    init(
        _ text: String,
        onHover: Binding<Bool>,
        fontSize: CGFloat = 12,
        bgColor: Color,
        hoverColor: Color,
        cornerRadius: CGFloat = 4
    ) {
        self.text = text
        self._hoverOn = onHover
        self.fontSize = fontSize
        self.bgColor = bgColor
        self.hoverColor = hoverColor
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Text(text)
            .font(.inter(.medium(size: fontSize)))
            .padding(.all, 4)
            .padding(.horizontal, 4)
            .background(hoverOn ? hoverColor : bgColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.3), radius: 1)
            .foregroundColor(themeSwitcher.selectedTheme.textColor)
            .onHover { hover in
                withAnimation {
                    hoverOn = hover
                }
            }
    }
}

struct HoverButton_Previews: PreviewProvider {
    static var previews: some View {
        HoverButton("My Button", onHover: .constant(false), bgColor: .blue, hoverColor: .red)
    }
}
