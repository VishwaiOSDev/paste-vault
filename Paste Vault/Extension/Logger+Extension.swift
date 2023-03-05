//
//  Logger+Extension.swift
//  Paste Vault
//
//  Created by Vishweshwaran on 05/03/23.
//

import LoggerKit

typealias Logger = PasteVaultApp.Logger

extension PasteVaultApp {
    
    struct Logger: Loggable {
        static var logTag: String = "Paste Vault"
        static var logConfig: LoggerKit.LoggerConfig = .init(enable: true, severity: .info)
    }
}
