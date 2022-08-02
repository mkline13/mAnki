//
//  Card.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//

import XCTest
@testable import FlashCards
import CoreData


class ModelConvenienceInitializerTests: XCTestCase {
    func testConvenienceInitializers() throws {
        let container = PersistentContainerHelper.shared.createPersistentContainer()
        
        let date = Date.now
        
        let contentPack = ContentPack(title: "testPackTitle", packDescription: "testPackDescription", author: "testAuthor", context: container.viewContext)
        let deck = Deck(title: "testDeckTitle", deckDescription: "testDeckDescription", newCardsPerDay: 10, reviewCardsLimit: 12, context: container.viewContext)
        let card = Card(frontContent: "front", backContent: "back", contentPack: contentPack, deck: deck, context: container.viewContext)
        let studyRecord = StudyRecord(timestamp: date, studyStatus: StudyStatus.success.description, previousInterval: 0, nextInterval: 3, card: card, context: container.viewContext)
        
        // MARK: test ContentPack convenience init
        XCTAssertEqual(contentPack.title, "testPackTitle", "Unexpected title")
        XCTAssertEqual(contentPack.packDescription, "testPackDescription", "Unexpected packDescription")
        XCTAssertEqual(contentPack.author, "testAuthor", "Unexpected author")
        XCTAssert(contentPack.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test Deck convenience init
        XCTAssertEqual(deck.title, "testDeckTitle", "Unexpected title")
        XCTAssertEqual(deck.deckDescription, "testDeckDescription", "Unexpected deckDescription")
        XCTAssertEqual(deck.newCardsPerDay, 10, "Unexpected newCardsPerDay")
        XCTAssertEqual(deck.reviewCardsLimit, 12, "Unexpected reviewCardsLimit")
        XCTAssert(deck.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test Card convenience init
        XCTAssertEqual(card.frontContent, "front", "Unexpected frontContent")
        XCTAssertEqual(card.backContent, "back", "Unexpected backContent")
        XCTAssertEqual(card.contentPack.objectID, contentPack.objectID, "Unexpected contentPack")
        XCTAssertEqual(card.deck.objectID, deck.objectID, "Unexpected deck")
        XCTAssert(card.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test StudyRecord convenience init
        XCTAssertEqual(studyRecord.timestamp, date, "Unexpected date")
        XCTAssertEqual(studyRecord.studyStatus, StudyStatus.success.description, "Unexpected studyStatus")
        XCTAssertEqual(studyRecord.previousInterval, 0, "Unexpected previousInterval")
        XCTAssertEqual(studyRecord.nextInterval, 3, "Unexpected nextInterval")
        XCTAssertEqual(studyRecord.card.objectID, card.objectID, "Unexpected card")
        XCTAssert(studyRecord.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
    }
}
