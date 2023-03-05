//
//  PresistenceController.swift
//  PasteVault
//
//  Created by Vishweshwaran on 24/07/22.
//

import CoreData
import LoggerKit

enum StorageType {
    case persistent, inMemory
}

class CoreDataStore {
    
    let container: NSPersistentContainer
    lazy var bgContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = false
        return context
    }()
    
    init(_ storageType: StorageType = .persistent) {
        container = NSPersistentContainer(name: "PasteVault")
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        container.loadPersistentStores { description, error in
            Logger.verbose("CoreData \(storageType) storage is loaded.")
            if let error = error {
                Logger.error("Setting up CoreData: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func addItemToCoreData(content: String) {
        bgContext.perform {
            let pasteModel = Paste(context: self.bgContext)
            pasteModel.id = UUID()
            pasteModel.content = content
            pasteModel.isPinned = false
            pasteModel.date = Date()
            do {
                try self.bgContext.saveIfNeeded()
            } catch {
                Logger.error("Failed to save in BGContext")
                Logger.verbose("Rolling back...")
                self.bgContext.rollback()
            }
        }
    }
    
    func updateThePinStatusInCoreData(at id: UUID) {
        bgContext.perform {
            let request: NSFetchRequest<Paste> = Paste.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
            do {
                let pasteItem = try self.bgContext.fetch(request)
                guard let item = pasteItem.first else { return }
                item.isPinned.toggle()
                try self.bgContext.saveIfNeeded()
            } catch {
                Logger.error("Failed to save in BGContext")
                Logger.verbose("Rolling back...")
                self.bgContext.rollback()
            }
        }
    }
    
    func deleteItemInCoreData(_ id: UUID) {
        bgContext.perform {
            let request: NSFetchRequest<Paste> = Paste.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
            do {
                let pasteItem = try self.bgContext.fetch(request)
                guard let item = pasteItem.first else { return }
                self.bgContext.delete(item)
                try self.bgContext.saveIfNeeded()
            } catch {
                Logger.error("Failed to save in BGContext")
                Logger.verbose("Rolling back...")
                self.bgContext.rollback()
            }
        }
    }
    
    func deleteAllItemsInCoreData() {
        let request: NSFetchRequest<NSFetchRequestResult> = Paste.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try container.viewContext.execute(batchDeleteRequest)
            container.viewContext.reset()
        } catch {
            Logger.error("Error deleting all data from CoreData: \(error.localizedDescription)")
            Logger.verbose("Rolling back...")
            container.viewContext.rollback()
        }
    }
}

