//
//  CoreDataTest+Extension.swift
//  PasteVaultTest
//
//  Created by Vishweshwaran on 17/08/22.
//

import Foundation
@testable import Paste_Vault

extension CoreDataTest {
    
    func insertPaste(for length: UInt) {
        let itemToBeCopied = "Pasteboard"
        for index in 1...length {
            testStorage.addItemToCoreData(content: "\(itemToBeCopied)_\(index)")
        }
    }
}
