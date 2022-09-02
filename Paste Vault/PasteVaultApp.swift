//
//  PasteVaultApp.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import SwiftUI
import FontKit
import FontInter

@main
struct PasteVaultApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appdelegate
    
    init() {
        FontKit.registerInter()
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
