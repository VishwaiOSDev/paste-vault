//
//  AppDelegate.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import Foundation
import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    static var popover = NSPopover()
    var statusBar: StatusBarService?
    let storage = CoreDataStore(.persistent)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let service: PasteboardServiceProtocol = PasteboardService()
        let viewModel = PasteViewModel(pasteboardService: service, storage: storage)
        let pasteView = PasteView<PasteViewModel>()
            .environment(\.managedObjectContext, storage.container.viewContext)
            .environmentObject(viewModel)
            .environmentObject(ThemeSwitcher())
            .preferredColorScheme(.dark)
        Self.popover.contentViewController = NSHostingController(rootView: pasteView)
        Self.popover.behavior = .transient
        statusBar = StatusBarService(Self.popover)
    }
}
