//
//  String+Extension.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import Foundation

extension String {
    /// `trim` will remove the white spaces in a `String`
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
