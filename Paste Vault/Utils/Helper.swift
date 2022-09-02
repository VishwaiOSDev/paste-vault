//
//  Enum.swift
//  PasteVault
//
//  Created by Vishweshwaran on 25/07/22.
//

import Foundation

enum ListType: CaseIterable {
    case all, pinned
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .pinned:
            return "Pinned"
        }
    }
}
