//
//  MOC+Extension.swift
//  PasteVault
//
//  Created by Vishweshwaran on 28/08/22.
//

import CoreData

extension NSManagedObjectContext {
    
    /// Only performs a save if there are changes to commit.
    /// - Returns: `true` if a save was needed. Otherwise, `false`.
    @discardableResult public func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}

