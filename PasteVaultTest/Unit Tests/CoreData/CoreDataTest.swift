//
//  CoreDataTest.swift
//  PasteVaultTest
//
//  Created by Vishweshwaran on 10/08/22.
//

import XCTest
import SwiftUI
import LogKit
@testable import Paste_Vault

final class CoreDataTest: XCTestCase {
    
    var testStorage: CoreDataStore!
    
    override func setUpWithError() throws {
        testStorage = CoreDataStore(.inMemory)
    }
    
    override func tearDownWithError() throws {
        testStorage = nil
    }
    
    func testPasteboardIsNilForFirstTime() {
        let context = testStorage.container.viewContext
        
        let allPasteboardItems = try! context.fetch(Paste.fetchRequest())
        
        XCTAssertEqual([], allPasteboardItems)
        XCTAssertEqual(0, allPasteboardItems.count)
    }
    
    func testSavingPasteIsValid() {
        let context = testStorage.bgContext
        let itemToBeCopied = "Pasteboard_01"
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        
        testStorage.addItemToCoreData(content: itemToBeCopied)
        
        waitForExpectations(timeout: 0.001) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        let fetchRequest: NSFetchRequest<Paste> = Paste.fetchRequest()
        let allPasteboardItems = try? context.fetch(fetchRequest)
        
        XCTAssertFalse(testStorage.bgContext.hasChanges)
        XCTAssertNotNil(allPasteboardItems)
        XCTAssertNotNil(allPasteboardItems!.first!.wrappedId)
        XCTAssertEqual(1, allPasteboardItems?.count)
        XCTAssertEqual("Pasteboard_01", allPasteboardItems!.first!.wrappedContent)
        XCTAssertFalse(allPasteboardItems!.first!.isPinned)
    }
    
    func testPiningPasteIsValid() {
        let context = testStorage.bgContext
        /// adding items to CoreData to test pin function
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        
        testStorage.addItemToCoreData(content: "This item is needed to be pinned.")
        
        waitForExpectations(timeout: 0.001) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        let fetchRequest: NSFetchRequest<Paste> = Paste.fetchRequest()
        var allPasteboardItems = try? context.fetch(fetchRequest)
        
        XCTAssertFalse(testStorage.bgContext.hasChanges)
        XCTAssertNotNil(allPasteboardItems)
        XCTAssertNotNil(allPasteboardItems!.first!.wrappedId)
        XCTAssertEqual(1, allPasteboardItems?.count)
        XCTAssertEqual("This item is needed to be pinned.", allPasteboardItems!.first!.wrappedContent)
        XCTAssertFalse(allPasteboardItems!.first!.isPinned)
        
        /// - Important: Testing the update pinning function
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        testStorage.updateThePinStatusInCoreData(at: allPasteboardItems!.first!.wrappedId)
        
        waitForExpectations(timeout: 0.001) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        allPasteboardItems = try? context.fetch(fetchRequest)
        
        XCTAssertFalse(testStorage.bgContext.hasChanges)
        XCTAssertNotNil(allPasteboardItems)
        XCTAssertNotNil(allPasteboardItems!.first!.wrappedId)
        XCTAssertEqual(1, allPasteboardItems!.count)
        XCTAssertEqual("This item is needed to be pinned.", allPasteboardItems!.first!.wrappedContent)
        XCTAssertTrue(allPasteboardItems!.first!.isPinned)
    }
    
    func testDeletePaste() {
        let context = testStorage.bgContext
        /// adding items to CoreData to test delete function
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        
        testStorage.addItemToCoreData(content: "This item is needed to be deleted.")
        
        waitForExpectations(timeout: 0.001) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        let fetchRequest: NSFetchRequest<Paste> = Paste.fetchRequest()
        var allPasteboardItems = try? context.fetch(fetchRequest)
        
        XCTAssertFalse(testStorage.bgContext.hasChanges)
        XCTAssertNotNil(allPasteboardItems)
        XCTAssertNotNil(allPasteboardItems!.first!.wrappedId)
        XCTAssertEqual(1, allPasteboardItems?.count)
        XCTAssertEqual("This item is needed to be deleted.", allPasteboardItems!.first!.wrappedContent)
        XCTAssertFalse(allPasteboardItems!.first!.isPinned)
        
        /// Delete item in CoreData
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        testStorage.deleteItemInCoreData(allPasteboardItems!.first!.wrappedId)
        
        waitForExpectations(timeout: 0.001) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        allPasteboardItems = try! context.fetch(Paste.fetchRequest())
        
        XCTAssertFalse(testStorage.bgContext.hasChanges)
        XCTAssertNotNil(allPasteboardItems)
        XCTAssertEqual([], allPasteboardItems)
        XCTAssertEqual(0, allPasteboardItems?.count)
    }
}
