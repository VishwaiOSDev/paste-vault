//
//  PasteVaultService.swift
//  PasteVault
//
//  Created by Vishweshwaran on 20/07/22.
//

import AppKit
import Combine
import LogKit

protocol PasteboardServiceProtocol {
    var recentlyCopiedText: PassthroughSubject<String, Never> { get set }
    
    func copyText(_ text: String)
}

protocol PasteboardUtilsProtocol {
    var pasteboard: NSPasteboard { get set }
    var changeCount: Int { get set }
    var timer: Timer? { get set }
    
    func startPolling()
    func getTheCopiedText()
    func checkForPasteboardChanges()
}

final class PasteboardService: PasteboardServiceProtocol, PasteboardUtilsProtocol {
    
    var recentlyCopiedText = PassthroughSubject<String, Never>()
    var pasteboard: NSPasteboard = .general
    var changeCount: Int
    var timer: Timer?
    
    init() {
        changeCount = pasteboard.changeCount
        startPolling()
    }
    
    func copyText(_ text: String) {
        changeCount = pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.checkForPasteboardChanges()
        })
    }
    
    func checkForPasteboardChanges() {
        if changeCount != pasteboard.changeCount {
            getTheCopiedText()
        }
        changeCount = pasteboard.changeCount
    }
    
    func getTheCopiedText() {
        pasteboard.string(forType: .string)
        guard let pasteboardItems = pasteboard.pasteboardItems else { return }
        guard let pasteboardContent = pasteboardItems.first else { return }
        guard let content = pasteboardContent.string(forType: .string) else { return }
        recentlyCopiedText.send(content.trim)
        Log.info("PUBLISHED THE COPIED CONTENT: \(content.trim)")
    }
    
    func stopPolling() {
        timer?.invalidate()
    }
}
