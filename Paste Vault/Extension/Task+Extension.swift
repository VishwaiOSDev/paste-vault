//
//  Task+Extension.swift
//  PasteVault
//
//  Created by Vishweshwaran on 24/07/22.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
