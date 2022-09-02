//
//  PasteVaultTest.swift
//  PasteVaultTest
//
//  Created by Vishweshwaran on 08/08/22.
//

import XCTest
import LogKit
import Combine
@testable import Paste_Vault

class PasteboardServiceTest: XCTestCase {
    
    var pasteboardService: PasteboardServiceProtocol!
    var anyCancellable: Set<AnyCancellable> = []
    
    override func setUp() {
        pasteboardService = PasteboardMockService()
    }
    
    func testCopyingTextToClipboard() {
        
        let expectation = self.expectation(description: "Should copy the text in pasteboard.")
        
        let copyString = "Content_To_Be_Copied"
        var recentlyCopiedContent: String?
        
        pasteboardService.recentlyCopiedText
            .sink { copiedText in
                recentlyCopiedContent = copiedText
                expectation.fulfill()
            }
            .store(in: &anyCancellable)
        
        pasteboardService.copyText(copyString)
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertEqual(recentlyCopiedContent!, "Content_To_Be_Copied")
    }
    
    func testCopyingTextWithSymbols() {
        
        let expectation = self.expectation(description: "Should copy the text to pasteboard with Symbols.")
        
        let copyString = "Content with Symbols: $19&^#(!#^"
        var recentlyCopiedContent: String?
        
        pasteboardService.recentlyCopiedText
            .sink { copiedText in
                recentlyCopiedContent = copiedText
                expectation.fulfill()
            }
            .store(in: &anyCancellable)
        
        pasteboardService.copyText(copyString)
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertEqual(recentlyCopiedContent!, "Content with Symbols: $19&^#(!#^")
    }
    
    func testCopyingTextWithWhiteSpaces() {
        
        let expectation = self.expectation(description: "Should remove the white spaces and copy text to pasteboard.")
        
        let copyString_01 = "\n\n\n\n This content is purely a demo \ncontent. \n\n\n"
        var recentlyCopiedContent: String?
        
        pasteboardService.recentlyCopiedText
            .sink { copiedText in
                recentlyCopiedContent = copiedText
                expectation.fulfill()
            }
            .store(in: &anyCancellable)
        
        pasteboardService.copyText(copyString_01)
        
        waitForExpectations(timeout: 3.0)
        
        XCTAssertEqual(recentlyCopiedContent!, "This content is purely a demo \ncontent.")
    }
}
