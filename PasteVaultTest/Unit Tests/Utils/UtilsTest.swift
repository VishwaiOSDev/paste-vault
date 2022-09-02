//
//  UtilsTest.swift
//  PasteVaultTest
//
//  Created by Vishweshwaran on 09/08/22.
//

import XCTest
@testable import Paste_Vault

final class UtilsTest: XCTestCase {
    
    override func setUp() { }
    
    func testTrimCharacters() {
        
        let trailingEmptySpace = "Trailing empty space.            "
        let leadingEmptySpace = "              Leading empty space."
        let inbetweenEmptySpaces = "Inbetween    Empt   y     space    ."
        let leadingAndTrailingEmptySpace = "    Demo Content ..    .    "
        let newLine = """
                      This feature looks cool.
                      
                      Yes buddy. That is really a cool
                      feature.
                      """
        let newLineInTrailing = "New line in trailing. \n\n\n\n\n"
        let newLineInLeading = "\n\n\n\n\n New line in leading."
        let newLineInLeadingAndTrailing = "\n\n\n\n New line in both \n\n\n\n"
        
        let trimmedTrailingEmptySpace = trailingEmptySpace.trim
        let trimmedLeadingEmptySpace = leadingEmptySpace.trim
        let trimmedInbetweenEmptySpaces = inbetweenEmptySpaces.trim
        let trimmedLeadingAndTrailingEmptySpace = leadingAndTrailingEmptySpace.trim
        let trimmedNewLine = newLine.trim
        let trimmedNewLineInTrailing = newLineInTrailing.trim
        let trimmedNewLineInLeading = newLineInLeading.trim
        let trimmedNewLineInLeadingAndTrailing = newLineInLeadingAndTrailing.trim
        
        XCTAssertEqual(trimmedTrailingEmptySpace, "Trailing empty space.")
        XCTAssertEqual(trimmedLeadingEmptySpace, "Leading empty space.")
        XCTAssertEqual(trimmedInbetweenEmptySpaces, "Inbetween    Empt   y     space    .")
        XCTAssertEqual(trimmedLeadingAndTrailingEmptySpace, "Demo Content ..    .")
        XCTAssertEqual(trimmedNewLine, "This feature looks cool.\n\nYes buddy. That is really a cool\nfeature.")
        XCTAssertEqual(trimmedNewLineInTrailing, "New line in trailing.")
        XCTAssertEqual(trimmedNewLineInLeading, "New line in leading.")
        XCTAssertEqual(trimmedNewLineInLeadingAndTrailing, "New line in both")
    }
}
