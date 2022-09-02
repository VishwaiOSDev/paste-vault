//
//  PasteCell.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import SwiftUI
import FontKit

struct PasteCell: View {
    
    @State var didTap: Bool = false
    @State var isHovering: Bool = false
    @EnvironmentObject var themeSwitcher: ThemeSwitcher
    
    let content: String
    let isPinned: Bool
    var didTapOnCellOrCopy: (String) -> Void
    var didTapDelete: () -> Void
    var didTapPin: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(content)
                    .font(.inter(.regular(size: 14)))
                    .foregroundColor(
                        didTap ?
                        themeSwitcher.selectedTheme.secondaryTextColor : isHovering ?
                        themeSwitcher.selectedTheme.secondaryTextColor : themeSwitcher.selectedTheme.textColor
                    )
                    .padding(.trailing)
                footerView
                    .padding(.top, 4)
                    .padding(.bottom, 6)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding([.leading, .top])
        .background(didTap ? themeSwitcher.selectedTheme.contrastColor: isHovering ? themeSwitcher.selectedTheme.hoverColor: Color.clear)
        .cornerRadius(6)
        .overlay(borderStroke)
        .scaleEffect(didTap ? 0.998 : isHovering ? 1.02 : 1.0)
        .onTapGesture(perform: onTap)
        .onHover { hover in
            withAnimation(.linear(duration: 0.3)) {
                isHovering = hover
            }
        }
    }
    
    private var footerView: some View {
        ZStack {
            copyTextView
                .isHidden(!didTap)
            iconStackView
                .padding(.trailing, 8)
        }
        .foregroundColor(themeSwitcher.selectedTheme.brandColor)
    }
    
    private var copyTextView: some View {
        Text("Copied!")
            .font(.inter(.bold(size: 14)))
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var iconStackView: some View {
        HStack(spacing: 6) {
            Image(systemName: isPinned ? "pin.fill" : "pin")
                .onTapGesture(perform: didTapPin)
            Image(systemName: "trash")
                .onTapGesture(perform: didTapDelete)
            Image(systemName: "doc.on.doc")
                .onTapGesture(perform: onTap)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .isHidden(didTap)
        .isHidden(!isHovering)
    }
    
    @ViewBuilder
    private var borderStroke: some View {
        if !isHovering {
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(themeSwitcher.selectedTheme.textColor, lineWidth: 1)
        }
    }
    
    private func onTap() {
        withAnimation { didTap = true }
        didTapOnCellOrCopy(content)
        Task {
            try await Task.sleep(seconds: 0.6)
            withAnimation { didTap = false }
        }
    }
}

struct PasteCell_Previews: PreviewProvider {
    static var previews: some View {
        PasteCell(
            content: "Empty Content Bro...",
            isPinned: false,
            didTapOnCellOrCopy: { _ in },
            didTapDelete: {},
            didTapPin: {}
        )
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
