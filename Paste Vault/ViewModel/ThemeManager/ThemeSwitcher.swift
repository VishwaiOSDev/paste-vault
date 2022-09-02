//
//  Theme.swift
//  PasteVault
//
//  Created by Vishweshwaran on 29/08/22.
//

import SwiftUI

protocol Theme {
    var brandColor: Color { get set }               // Frame
    var secondaryColor: Color { get set }           // Quit Button
    var contrastSecondaryColor: Color{ get set }    // Quit Button Hover
    var textColor: Color { get set }                // Normal Text
    var secondaryTextColor: Color { get set }       // Text while hovering
    var hoverColor: Color { get set }               // Hover background
    var contrastColor: Color { get set }            // onTap on cell
}

final class ThemeSwitcher: ObservableObject {
    
    @AppStorage("selectedTheme") var themeName: ThemeName = .blue {
        didSet {
            updateTheme()
        }
    }
    @Published var selectedTheme: Theme = BlueTheme()
    
    init() {
        updateTheme()
    }
    
    func updateTheme() {
        DispatchQueue.main.async {
            withAnimation {
                self.selectedTheme = ThemeManager.getTheme(self.themeName)
            }
        }
    }
}
