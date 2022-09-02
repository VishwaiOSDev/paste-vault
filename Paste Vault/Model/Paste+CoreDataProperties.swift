//
//  Paste+CoreDataProperties.swift
//  PasteVault
//
//  Created by Vishweshwaran on 24/07/22.
//
//

import Foundation
import CoreData

extension Paste {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paste> {
        return NSFetchRequest<Paste>(entityName: "Paste")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var isPinned: Bool
    
    public var wrappedContent: String {
        content ?? "NO DATA"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
}

extension Paste {
    
    static func getAllPaste() -> NSFetchRequest<Paste> {
        let request: NSFetchRequest<Paste> = Paste.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Paste.date, ascending: false)]
        request.fetchBatchSize = 10
        request.returnsObjectsAsFaults = false
        return request
    }
    
    static func getPinnedPaste() -> NSFetchRequest<Paste> {
        let request: NSFetchRequest<Paste> = Paste.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Paste.date, ascending: false)]
        request.predicate = NSPredicate(format: "isPinned == %@", NSNumber(value: true))
        request.fetchBatchSize = 10
        return request
    }
}

extension Paste {
    
    @objc
    public var sections: String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        guard let date = date else { return "undated" }
        return relativeDateFormatter.string(from: date)
    }
}
