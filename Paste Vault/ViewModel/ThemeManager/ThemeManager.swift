//
//  ThemeManager.swift
//  PasteVault
//
//  Created by Vishweshwaran on 29/08/22.
//

import Foundation

enum ThemeName: String, Codable, CaseIterable {
    case blue, bluish, pinky, teal, tomato
    
    var title: String {
        switch self {
        case .blue:
            return "Blue"
        case .bluish:
            return "Bluish"
        case .pinky:
            return "Pinky"
        case .tomato:
            return "Tomato"
        case .teal:
            return "Teal"
        }
    }
}

enum ThemeManager {
    static let themes: [Theme] = [BlueTheme(), BluishTheme(), PinkyTheme(), TomatoTheme(), TealTheme()]
    
    static func getTheme(_ theme: ThemeName) -> Theme {
        switch theme {
        case .blue:
            return Self.themes[0]
        case .bluish:
            return Self.themes[1]
        case .pinky:
            return Self.themes[2]
        case .tomato:
            return Self.themes[3]
        case .teal:
            return Self.themes[4]
        }
    }
}
