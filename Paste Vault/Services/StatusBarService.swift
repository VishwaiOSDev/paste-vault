//
//  StatusBarService.swift
//  PasteVault
//
//  Created by Vishweshwaran on 22/07/22.
//

import AppKit
import SwiftUI

class StatusBarService {
    
    private(set) var statusItem: NSStatusItem!
    private(set) var popover: NSPopover
    private lazy var menuBarView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()
    
    init(_ popover: NSPopover) {
        self.popover = popover
        setupUpMenuBar()
    }
    
    @objc func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            guard let menuButton = statusItem.button else { return }
            popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            /// This piece of code will make sure to select `PasteVolt` as a keyView
            popover.contentViewController?.view.window?.makeKeyAndOrderFront(nil)
        }
    }
}

extension StatusBarService {
    
    func setupUpMenuBar() {
        popover.contentSize = NSSize(width: 400, height: 500)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let menuBarView = self.menuBarView,
              let menuButton = statusItem.button
        else { return }
        let hostingView = NSHostingView(rootView: MenuBarView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        menuBarView.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: menuBarView.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: menuBarView.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: menuBarView.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: menuBarView.leftAnchor)
        ])
        menuButton.target = self
        menuButton.action = #selector(showApp(sender:))
    }
}

