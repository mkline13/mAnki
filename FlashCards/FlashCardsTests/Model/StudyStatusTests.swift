//
//  FlashCardsTests.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//

import XCTest
@testable import FlashCards

class StudyStatusTests: XCTestCase {
    func testFromStringDeprecated() {
        XCTAssertEqual(StudyResult.fromString("aosdinbaoifbn"), .deprecated)
        XCTAssertEqual(StudyResult.fromString("deprecated"), .deprecated)
        
        XCTAssertNotEqual(StudyResult.fromString("failure"), .deprecated)
        XCTAssertNotEqual(StudyResult.fromString("success"), .deprecated)
    }
    
    func testFromStringFailure() {
        XCTAssertEqual(StudyResult.fromString("failure"), .failure)
        
        XCTAssertNotEqual(StudyResult.fromString("success"), .failure)
        XCTAssertNotEqual(StudyResult.fromString("aosdinbaoifbn"), .failure)
    }
    
    func testFromStringSuccess() {
        XCTAssertEqual(StudyResult.fromString("success"), .success)
        
        XCTAssertNotEqual(StudyResult.fromString("failure"), .success)
        XCTAssertNotEqual(StudyResult.fromString("successsss"), .success)
    }
    
    func testDescriptionMatchesFromString() {
        for c in StudyResult.allCases {
            let status = StudyResult.fromString(c.description)
            XCTAssertEqual(c, status)
        }
    }
}
