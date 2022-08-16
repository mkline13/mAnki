//
//  ManagedObjectTests.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//

import XCTest
@testable import FlashCards
import CoreData


class ManagedObjectTests: XCTestCase {
    override class func setUp() {
        dependencyContainer = DependencyContainer(creationMethod: PersistentContainerHelper.shared.createPersistentContainerWithInMemoryStores)
    }
    
    override func setUp() {
        // MARK: set up dependencies
        container = ManagedObjectTests.dependencyContainer.persistentContainer
        date = Date.now
        
        // MARK: run code to be tested
        contentPack = ContentPack(title: "testPackTitle", packDescription: "testPackDescription", author: "testAuthor", context: container.viewContext)
        deck = Deck(title: "testDeckTitle", deckDescription: "testDeckDescription", newCardsPerDay: 10, reviewCardsPerDay: 12, context: container.viewContext)
        card = Card(creationDate: date, frontContent: "Card Front", backContent: "Card Back", interval: 11, dueDate: date, contentPack: contentPack, deck: deck, context: container.viewContext)
        studyRecord = StudyRecord(timestamp: date, studyStatus: StudyResult.success, afterInterval: 10, card: card, context: container.viewContext)
    }
    
    override func tearDown() {
        // MARK: run code to be tested
        
        container.viewContext.delete(contentPack)
        container.viewContext.delete(deck)
        container.viewContext.delete(card)
        container.viewContext.delete(studyRecord)
        
        contentPack = nil
        deck = nil
        card = nil
        studyRecord = nil
    }
    
    func testConvenienceInitializers() throws {
        // MARK: test ContentPack convenience init
        XCTAssertEqual(contentPack.title, "testPackTitle", "Unexpected title")
        XCTAssertEqual(contentPack.packDescription, "testPackDescription", "Unexpected packDescription")
        XCTAssertEqual(contentPack.author, "testAuthor", "Unexpected author")
        XCTAssert(contentPack.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test Deck convenience init
        XCTAssertEqual(deck.title, "testDeckTitle", "Unexpected title")
        XCTAssertEqual(deck.deckDescription, "testDeckDescription", "Unexpected deckDescription")
        XCTAssertEqual(deck.dailyNewCardLimit, 10, "Unexpected newCardsPerDay")
        XCTAssertEqual(deck.dailyReviewCardLimit, 12, "Unexpected reviewCardsLimit")
        XCTAssertEqual(deck.previousStudySession, nil)
        XCTAssertEqual(deck.newCardsStudiedToday, 0)
        XCTAssertEqual(deck.reviewCardsStudiedToday, 0)
        
        XCTAssert(deck.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test Card convenience init
        XCTAssertEqual(card.creationDate, date, "Unexpected creationDate")
        XCTAssertEqual(card.frontContent, "Card Front", "Unexpected frontContent")
        XCTAssertEqual(card.backContent, "Card Back", "Unexpected backContent")
        
        XCTAssertEqual(card.srsInterval, 11, "Unexpected srsInterval")
        XCTAssertEqual(card.srsDueDate, date, "Unexpected srsDueDate")
        XCTAssertEqual(card.studyStatus, Card.Status.new.rawValue, "Unexpected studyStatus")
        
        XCTAssertEqual(card.contentPack, contentPack, "Unexpected contentPack")
        XCTAssertEqual(card.deck, deck, "Unexpected deck")
        XCTAssert(card.studyRecords.contains(studyRecord as Any), "Expected studyRecords to contain something")
        
        XCTAssert(card.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
        
        // MARK: test StudyRecord convenience init
        XCTAssertEqual(studyRecord.timestamp, date, "Unexpected timestamp")
        XCTAssertEqual(studyRecord.studyResult, StudyResult.success.rawValue, "Unexpected studyResult")
        XCTAssertEqual(studyRecord.afterInterval, 10, "Unexpected afterInterval")
        XCTAssertEqual(studyRecord.card, card, "Unexpected card")
        
        XCTAssert(studyRecord.managedObjectContext == container.viewContext, "Unexpected managedObjectContext")
    }
    
    func testDeckComputedVars() throws {
        // MARK: Deck
        XCTAssertEqual(deck.newCardsNeeded, 10, "Unexpected newCardsNeeded")
        XCTAssertEqual(deck.reviewCardsNeeded, 12, "Unexpected reviewCardsNeeded")
        
        deck.newCardsStudiedToday = 4
        deck.reviewCardsStudiedToday = 2
        
        XCTAssertEqual(deck.newCardsNeeded, 6, "Unexpected newCardsNeeded")
        XCTAssertEqual(deck.reviewCardsNeeded, 10, "Unexpected reviewCardsNeeded")
        
        // MARK: Card
        XCTAssertEqual(card.studyStatus, Card.Status.new.rawValue, "Unexpected studyStatus")
        
        card.status = Card.Status.learning
        XCTAssertEqual(card.studyStatus, Card.Status.learning.rawValue, "Unexpected studyStatus")
        
        card.studyStatus = Card.Status.review.rawValue
        XCTAssertEqual(card.status, Card.Status.review, "Unexpected studyStatus")
        
        // MARK: Study Record
        studyRecord.studyStatus = StudyResult.failure
        XCTAssertEqual(studyRecord.studyStatus, StudyResult.failure)
        
        studyRecord.studyResult = StudyResult.success.rawValue
        XCTAssertEqual(studyRecord.studyStatus, StudyResult.success)
    }
    
    // MARK: Properties
    private static var dependencyContainer: DependencyContainer!
    private var container: NSPersistentContainer!
    
    private var date: Date!
    private var contentPack: ContentPack!
    private var deck: Deck!
    private var card: Card!
    private var studyRecord: StudyRecord!
}
