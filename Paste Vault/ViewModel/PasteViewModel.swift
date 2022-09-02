//
//  PasteViewModel.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import SwiftUI
import AppKit
import Combine
import LogKit

typealias Pasteable = ObservableObject & PasteableActions

protocol AppLifeCycleProtocol {
    func terminateApplication()
}

protocol PasteableActions: AppLifeCycleProtocol {
    func copyTheSelectedItem(_ contentToBeCopied: String)
    func deletePasteItem(at pasteItem: UUID)
    func pinTheSelectedItem(_ pasteItem: UUID)
    func deleteAllPasteItems()
}

final class PasteViewModel: Pasteable {
    
    private var pasteBoard: NSPasteboard = NSPasteboard.general
    private var pasteboardService: PasteboardServiceProtocol
    private var anyCancellable = Set<AnyCancellable>()
    let storage: CoreDataStore
    
    init(pasteboardService: PasteboardServiceProtocol, storage: CoreDataStore) {
        self.pasteboardService = pasteboardService
        self.storage = storage
        syncThePasteBoard()
    }
    
    func copyTheSelectedItem(_ contentToBeCopied: String) {
        pasteboardService.copyText(contentToBeCopied)
    }
    
    func deletePasteItem(at pasteItem: UUID) {
        storage.deleteItemInCoreData(pasteItem)
    }
    
    func deleteAllPasteItems() {
        storage.deleteAllItemsInCoreData()
    }
    
    func pinTheSelectedItem(_ pasteItem: UUID) {
        storage.updateThePinStatusInCoreData(at: pasteItem)
    }
    
    private func syncThePasteBoard() {
        pasteboardService.recentlyCopiedText
            .removeDuplicates()
            .sink { copiedText in
                self.storage.addItemToCoreData(content: copiedText)
            }
            .store(in: &anyCancellable)
    }
    
    deinit {
        Log.info("Deinited.")
    }
}

// MARK: - Protocol Extension for terminating application
extension AppLifeCycleProtocol {
    
    func terminateApplication() {
        NSApplication.shared.terminate(nil)
    }
}
