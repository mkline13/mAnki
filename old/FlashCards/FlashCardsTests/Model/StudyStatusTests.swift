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
        XCTAssertEqual(StudyStatus.fromString("aosdinbaoifbn"), .deprecated)
        XCTAssertEqual(StudyStatus.fromString("deprecated"), .deprecated)
        
        XCTAssertNotEqual(StudyStatus.fromString("failure"), .deprecated)
        XCTAssertNotEqual(StudyStatus.fromString("success"), .deprecated)
    }
    
    func testFromStringFailure() {
        XCTAssertEqual(StudyStatus.fromString("failure"), .failure)
        
        XCTAssertNotEqual(StudyStatus.fromString("success"), .failure)
        XCTAssertNotEqual(StudyStatus.fromString("aosdinbaoifbn"), .failure)
    }
    
    func testFromStringSuccess() {
        XCTAssertEqual(StudyStatus.fromString("success"), .success)
        
        XCTAssertNotEqual(StudyStatus.fromString("failure"), .success)
        XCTAssertNotEqual(StudyStatus.fromString("successsss"), .success)
    }
    
    func testDescriptionMatchesFromString() {
        for c in StudyStatus.allCases {
            let status = StudyStatus.fromString(c.description)
            XCTAssertEqual(c, status)
        }
    }
}
