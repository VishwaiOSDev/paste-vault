//
//  PasteVaultMockService.swift
//  PasteVaultTest
//
//  Created by Vishweshwaran on 09/08/22.
//

import Foundation
import AppKit
import Combine
import LogKit
@testable import Paste_Vault

class PasteboardMockService: PasteboardServiceProtocol, PasteboardUtilsProtocol {
    
    var recentlyCopiedText = PassthroughSubject<String, Never>()
    var pasteboard: NSPasteboard = .general
    var changeCount: Int
    var timer: Timer?
    
    init() {
        changeCount = pasteboard.changeCount
        startPolling()
    }
    
    func copyText(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    func getTheCopiedText() {
        pasteboard.string(forType: .string)
        guard let pasteboardItems = pasteboard.pasteboardItems else { return }
        guard let pasteboardContent = pasteboardItems.first else { return }
        guard let content = pasteboardContent.string(forType: .string) else { return }
        recentlyCopiedText.send(content.trim)
        Log.info("PUBLISHED THE COPIED CONTENT(MOCK): \(content.trim)")
    }
    
    func checkForPasteboardChanges() {
        if changeCount != pasteboard.changeCount {
            getTheCopiedText()
        }
    }
}

extension PasteboardUtilsProtocol {
    
    func startPolling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            checkForPasteboardChanges()
        }
    }
}
