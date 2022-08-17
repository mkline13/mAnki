//
//  SRSServiceTests.swift
//  FlashCardsTests
//
//  Created by Work on 8/16/22.
//


import XCTest
@testable import FlashCards
import CoreData



class SRSServiceTests: XCTestCase {
    func testCalculateInterval() {
        let srs = SRSService(firstInterval: 1, secondInterval: 6, multiplier: 2.0)
        
        var interval = srs.calculateInterval(previousInterval: 0, studyStatus: .success)
        XCTAssertEqual(interval, 1, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 0, studyStatus: .failure)
        XCTAssertEqual(interval, 0, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 1, studyStatus: .failure)
        XCTAssertEqual(interval, 0, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 1, studyStatus: .success)
        XCTAssertEqual(interval, 6, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 6, studyStatus: .failure)
        XCTAssertEqual(interval, 0, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 6, studyStatus: .success)
        XCTAssertEqual(interval, 12, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 12, studyStatus: .failure)
        XCTAssertEqual(interval, 0, "Unexpected Interval")
        
        interval = srs.calculateInterval(previousInterval: 12, studyStatus: .success)
        XCTAssertEqual(interval, 24, "Unexpected Interval")
        
        // test with different intervals
        let anotherSrs = SRSService(firstInterval: 2, secondInterval: 5, multiplier: 3.0)
        
        interval = anotherSrs.calculateInterval(previousInterval: 0, studyStatus: .failure)
        XCTAssertEqual(interval, 0, "Unexpected Interval")
        
        interval = anotherSrs.calculateInterval(previousInterval: 0, studyStatus: .success)
        XCTAssertEqual(interval, 2, "Unexpected Interval")
        
        interval = anotherSrs.calculateInterval(previousInterval: 1, studyStatus: .success)
        XCTAssertEqual(interval, 2, "Unexpected Interval")
        
        interval = anotherSrs.calculateInterval(previousInterval: 2, studyStatus: .success)
        XCTAssertEqual(interval, 5, "Unexpected Interval")
        
        interval = anotherSrs.calculateInterval(previousInterval: 5, studyStatus: .success)
        XCTAssertEqual(interval, 15, "Unexpected Interval")
        
        interval = anotherSrs.calculateInterval(previousInterval: 15, studyStatus: .success)
        XCTAssertEqual(interval, 45, "Unexpected Interval")
    }
    
    func testComputeNewStatus() {
        let dependencyContainer = DependencyContainer(creationMethod: PersistentContainerHelper.shared.createPersistentContainerWithInMemoryStores)
        let persistentContainer = dependencyContainer.persistentContainer
        
        let srs = SRSService()
        
        let pack = ContentPack(title: "TITLE", packDescription: "DESC", author: "AUTH", context: persistentContainer.viewContext)
        let card = Card(creationDate: Date.now, frontContent: "Front", backContent: "Back", interval: 22, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        
        // .new
        XCTAssertEqual(card.status, Card.Status.new)
        
        var status = srs.computeNewStatus(for: card, studyResult: .failure)
        XCTAssertEqual(status, Card.Status.learning)
        
        status = srs.computeNewStatus(for: card, studyResult: .success)
        XCTAssertEqual(status, Card.Status.review)
        
        // .review
        card.status = .review
        
        status = srs.computeNewStatus(for: card, studyResult: .failure)
        XCTAssertEqual(status, Card.Status.learning)
        
        status = srs.computeNewStatus(for: card, studyResult: .success)
        XCTAssertEqual(status, Card.Status.review)
        
        // .learning
        card.status = .learning
        
        status = srs.computeNewStatus(for: card, studyResult: .failure)
        XCTAssertEqual(status, Card.Status.learning)
        
        status = srs.computeNewStatus(for: card, studyResult: .success)
        XCTAssertEqual(status, Card.Status.review)
    }
}
