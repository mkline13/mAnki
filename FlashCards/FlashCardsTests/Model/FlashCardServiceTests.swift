//
//  FlashCardServiceTests.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//


import XCTest
@testable import FlashCards
import CoreData


class FlashCardServiceTests: XCTestCase {
    // MARK: Properties
    var dependencyContainer: DependencyContainer!
    var persistentContainer: NSPersistentContainer!
    var flashCardService: FlashCardService!

    
    // MARK: Test Life Cycle
    override func setUp() {
        dependencyContainer = DependencyContainer(creationMethod: PersistentContainerHelper.shared.createPersistentContainerWithInMemoryStores)
        persistentContainer = dependencyContainer.persistentContainer
        flashCardService = dependencyContainer.flashCardService
    }

    override func tearDown() {
        flashCardService = nil
        persistentContainer = nil
        dependencyContainer = nil
    }

    // MARK: Tests
    
    // MARK: - CREATE
    func testNewContentPack() {
        guard let pack = flashCardService.newContentPack(title: "testPackTitle", description: "testPackDescription", author: "testAuthor") else {
            XCTFail("newContentPack did not return a ContentPack instance as expected")
            return
        }

        // Test method parameters
        XCTAssertEqual(pack.title, "testPackTitle", "Unexpected title")
        XCTAssertEqual(pack.packDescription, "testPackDescription", "Unexpected packDescription")
        XCTAssertEqual(pack.author, "testAuthor", "Unexpected author")

        // Test if object was successfully stored
        let fetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedPacks = try? context.fetch(fetchRequest) else {
                XCTFail("Failed to fetch ContentPacks")
                return
            }
            XCTAssertEqual(fetchedPacks.count, 1, "Unexpected number of ContentPacks fetched: \(fetchedPacks.count), expected 1")

            let fetchedPack: ContentPack = fetchedPacks[0]
            XCTAssertEqual(fetchedPack.title, "testPackTitle")
            XCTAssertEqual(fetchedPack.packDescription, "testPackDescription")
            XCTAssertEqual(fetchedPack.author, "testAuthor")

            XCTAssertEqual(fetchedPack.objectID, pack.objectID, "Unexpected objectID")
        }
    }

    func testNewCard() {
        let contentPack = ContentPack(title: "Pack", packDescription: "Pack Description", author: "Author", context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        guard let card = flashCardService.newCard(in: contentPack, frontContent: "Card Front", backContent: "Card Back", deck: nil) else {
            XCTFail("newCard did not return a new Card")
            return
        }
        
        // Test method parameters
        XCTAssertEqual(card.contentPack, contentPack, "Unexpected contentPack")
        XCTAssertEqual(card.frontContent, "Card Front", "Unexpected frontContent")
        XCTAssertEqual(card.backContent, "Card Back", "Unexpected backContent")
        XCTAssertEqual(card.deck, nil, "Unexpected deck")
        
        // Test storage
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedCards = try? context.fetch(fetchRequest) else {
                XCTFail("Failed to fetch Cards")
                return
            }
            XCTAssertEqual(fetchedCards.count, 1, "Unexpected number of cards fetched")
            
            let fetchedCard: Card = fetchedCards[0]
            XCTAssertEqual(fetchedCard.objectID, card.objectID, "Unexpected card")
        }
    }
    
    func testNewDeck() {
        guard let deck = flashCardService.newDeck(title: "Title", description: "Description", newCardsPerDay: 22, reviewCardsPerDay: 33) else {
            XCTFail("newDeck did not return a new Deck")
            return
        }
        
        // Test method parameters
        XCTAssertEqual(deck.title, "Title", "Unexpected title")
        XCTAssertEqual(deck.deckDescription, "Description", "Unexpected deckDescription")
        XCTAssertEqual(deck.dailyNewCardLimit, 22, "Unexpected dailyNewCardLimit")
        XCTAssertEqual(deck.dailyReviewCardLimit, 33, "Unexpected dailyReviewCardLimit")
        
        // Test storage
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchResult = try? context.fetch(fetchRequest) else {
                XCTFail("Failed to fetch Decks")
                return
            }
            XCTAssertEqual(fetchResult.count, 1, "Unexpected number of decks fetched")
            
            let fetchedDeck: Deck = fetchResult[0]
            XCTAssertEqual(fetchedDeck.objectID, deck.objectID, "Unexpected deck")
        }
    }
    
    func testCreateNewStudyRecord() {
        let pack = ContentPack(title: "title", packDescription: "desc", author: "author", context: persistentContainer.viewContext)
        let card = Card(creationDate: Date.now, frontContent: "front", backContent: "back", interval: 0, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        guard let studyRecord = flashCardService.createStudyRecord(for: card, studyStatus: .failure, afterInterval: card.srsInterval) else {
            XCTFail("createStudyRecord did not return a new StudyRecord")
            return
        }
        
        // Test method parameters
        XCTAssertEqual(studyRecord.card.objectID, card.objectID, "Unexpected card")
        XCTAssertEqual(studyRecord.studyResult, StudyResult.failure.rawValue, "Unexpected studyResult")
        XCTAssertEqual(studyRecord.afterInterval, card.srsInterval, "Unexpected afterInterval")
        
        // Test storage
        let fetchRequest: NSFetchRequest<StudyRecord> = StudyRecord.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchResult = try? context.fetch(fetchRequest) else {
                XCTFail("Failed to fetch Decks")
                return
            }
            XCTAssertEqual(fetchResult.count, 1, "Unexpected number of records fetched")
            
            let fetchedRecord: StudyRecord = fetchResult[0]
            XCTAssertEqual(fetchedRecord.objectID, studyRecord.objectID, "Unexpected studyRecord")
        }
    }
    
    // MARK: - READ
    func testContentPackResultsController() {
        // Setup test data
        let delegate = MockNSFetchedResultsControllerDelegate()
        
        _ = ContentPack(title: "title1", packDescription: "desc1", author: "auth1", context: persistentContainer.viewContext)
        _ = ContentPack(title: "title2", packDescription: "desc2", author: "auth2", context: persistentContainer.viewContext)
        _ = ContentPack(title: "title3", packDescription: "desc3", author: "auth3", context: persistentContainer.viewContext)
        _ = ContentPack(title: "title4", packDescription: "desc4", author: "auth4", context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()

        // Perform test
        let resultsController = flashCardService.contentPackResultsController(with: delegate)

        XCTAssertTrue(resultsController!.delegate === delegate, "Results controller delegate was unexpected instance")

        // Validate results
        guard let resultsControllerFetchedObjects = resultsController!.fetchedObjects else {
            XCTFail("resultsControllerFetchedObjects is nil")
            return
        }
        XCTAssertEqual(resultsControllerFetchedObjects.count, 4, "Unexpected number of objects")

        let fetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ContentPack.title, ascending: true)]
        let fetchedResults = try! persistentContainer.viewContext.fetch(fetchRequest)

        XCTAssertEqual(resultsControllerFetchedObjects.count, fetchedResults.count, "Unexpected fetchedResults count")
        for (index, contentPack) in fetchedResults.enumerated() {
            XCTAssertEqual(resultsControllerFetchedObjects[index].title, contentPack.title, "Unexpected object sort")
        }
    }
    
    func testDeckResultsController() {
        // Setup test data
        let delegate = MockNSFetchedResultsControllerDelegate()
        
        _ = Deck(title: "Deck1", deckDescription: "Description1", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        _ = Deck(title: "Deck2", deckDescription: "Description2", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        _ = Deck(title: "Deck3", deckDescription: "Description3", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        _ = Deck(title: "Deck4", deckDescription: "Description4", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Perform test
        let resultsController = flashCardService.deckResultsController(with: delegate)

        XCTAssertTrue(resultsController!.delegate === delegate, "Results controller delegate was unexpected instance")

        // Validate results
        guard let resultsControllerFetchedObjects = resultsController!.fetchedObjects else {
            XCTFail("resultsControllerFetchedObjects is nil")
            return
        }
        XCTAssertEqual(resultsControllerFetchedObjects.count, 4, "Unexpected number of objects")

        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        let fetchedResults = try! persistentContainer.viewContext.fetch(fetchRequest)

        XCTAssertEqual(resultsControllerFetchedObjects.count, fetchedResults.count, "Unexpected fetchedResults count")
        for (index, deck) in fetchedResults.enumerated() {
            XCTAssertEqual(resultsControllerFetchedObjects[index].title, deck.title, "Unexpected object sort")
        }
    }
    
    func testCardResultsController() {
        // Setup test data
        let delegate = MockNSFetchedResultsControllerDelegate()
        
        let pack = ContentPack(title: "title", packDescription: "desc", author: "auth", context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Perform test
        let resultsController = flashCardService.cardResultsController(with: delegate)

        XCTAssertTrue(resultsController!.delegate === delegate, "Results controller delegate was unexpected instance")

        // Validate results
        guard let resultsControllerFetchedObjects = resultsController!.fetchedObjects else {
            XCTFail("resultsControllerFetchedObjects is nil")
            return
        }
        XCTAssertEqual(resultsControllerFetchedObjects.count, 4, "Unexpected number of objects")

        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)]
        let fetchedResults = try! persistentContainer.viewContext.fetch(fetchRequest)

        XCTAssertEqual(resultsControllerFetchedObjects.count, fetchedResults.count, "Unexpected fetchedResults count")
        for (index, card) in fetchedResults.enumerated() {
            XCTAssertEqual(resultsControllerFetchedObjects[index].frontContent, card.frontContent, "Unexpected object sort")
        }
    }
    
    func testCardResultsControllerForDeck() {
        // Setup test data
        let delegate = MockNSFetchedResultsControllerDelegate()
        
        let pack = ContentPack(title: "PackTitle", packDescription: "PackDesc", author: "PackAuthor", context: persistentContainer.viewContext)
        let deck = Deck(title: "DeckTitle", deckDescription: "DeckDesc", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)
        
        _ = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Perform test
        let resultsController = flashCardService.cardResultsController(with: delegate, for: deck)

        XCTAssertTrue(resultsController!.delegate === delegate, "Results controller delegate was unexpected instance")

        // Validate results
        guard let resultsControllerFetchedObjects = resultsController!.fetchedObjects else {
            XCTFail("resultsControllerFetchedObjects is nil")
            return
        }
        XCTAssertEqual(resultsControllerFetchedObjects.count, 3, "Unexpected number of objects")

        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "deck == %@", deck)
        let fetchedResults = try! persistentContainer.viewContext.fetch(fetchRequest)

        XCTAssertEqual(resultsControllerFetchedObjects.count, fetchedResults.count, "Unexpected fetchedResults count")
        for (index, card) in fetchedResults.enumerated() {
            XCTAssertEqual(resultsControllerFetchedObjects[index].frontContent, card.frontContent, "Unexpected object sort")
        }
    }
    
    func testCardResultsControllerForPack() {
        // Setup test data
        let delegate = MockNSFetchedResultsControllerDelegate()
        
        let pack = ContentPack(title: "PackTitle", packDescription: "PackDesc", author: "PackAuthor", context: persistentContainer.viewContext)
        let dummyPack = ContentPack(title: "DummyTitle", packDescription: "Dummyyyy", author: "Dumbo", context: persistentContainer.viewContext)
        
        let deck = Deck(title: "DeckTitle", deckDescription: "DeckDesc", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)
        
        _ = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: nil, contentPack: dummyPack, deck: nil, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Perform test
        let resultsController = flashCardService.cardResultsController(with: delegate, for: pack)

        XCTAssertTrue(resultsController!.delegate === delegate, "Results controller delegate was unexpected instance")

        // Validate results
        guard let resultsControllerFetchedObjects = resultsController!.fetchedObjects else {
            XCTFail("resultsControllerFetchedObjects is nil")
            return
        }
        XCTAssertEqual(resultsControllerFetchedObjects.count, 3, "Unexpected number of objects")

        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "contentPack == %@", pack)
        let fetchedResults = try! persistentContainer.viewContext.fetch(fetchRequest)

        XCTAssertEqual(resultsControllerFetchedObjects.count, fetchedResults.count, "Unexpected fetchedResults count")
        for (index, card) in fetchedResults.enumerated() {
            XCTAssertEqual(resultsControllerFetchedObjects[index].frontContent, card.frontContent, "Unexpected object sort")
        }
    }
    
    func testGetDecks() {
        // Setup test data

        let d0 = Deck(title: "Deck1", deckDescription: "Description1", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        let d1 = Deck(title: "Deck2", deckDescription: "Description2", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        let d2 = Deck(title: "Deck3", deckDescription: "Description3", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        let d3 = Deck(title: "Deck4", deckDescription: "Description4", newCardsPerDay: 1, reviewCardsPerDay: 2, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        let decks = flashCardService.getDecks()
        XCTAssertEqual(decks.count, 4)
        
        XCTAssertEqual(decks[0].objectID, d0.objectID)
        XCTAssertEqual(decks[1].objectID, d1.objectID)
        XCTAssertEqual(decks[2].objectID, d2.objectID)
        XCTAssertEqual(decks[3].objectID, d3.objectID)
    }
    
    func testGetCards() {
        // Setup test data
        
        let pack = ContentPack(title: "TITLE", packDescription: "DESC", author: "AUTH", context: persistentContainer.viewContext)
        let c0 = Card(creationDate: Date.now, frontContent: "Front0", backContent: "Back0", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c1 = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c2 = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c3 = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        let cards = flashCardService.getCards()
        XCTAssertEqual(cards.count, 4)
        
        XCTAssertEqual(cards[0].objectID, c0.objectID)
        XCTAssertEqual(cards[1].objectID, c1.objectID)
        XCTAssertEqual(cards[2].objectID, c2.objectID)
        XCTAssertEqual(cards[3].objectID, c3.objectID)
    }
    
    func testGetCardsInDeck() {
        // Setup test data
        
        let deck1 = Deck(title: "Deck1", deckDescription: "AboutMyDeck", newCardsPerDay: 12, reviewCardsPerDay: 14, context: persistentContainer.viewContext)
        let deck2 = Deck(title: "Deck2", deckDescription: "This is a deck", newCardsPerDay: 44, reviewCardsPerDay: 55, context: persistentContainer.viewContext)
        let pack = ContentPack(title: "TITLE", packDescription: "DESC", author: "AUTH", context: persistentContainer.viewContext)
        
        let c0 = Card(creationDate: Date.now, frontContent: "Front0", backContent: "Back0", interval: 1, dueDate: nil, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c1 = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c2 = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c3 = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c4 = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c5 = Card(creationDate: Date.now, frontContent: "Front5", backContent: "Back5", interval: 1, dueDate: nil, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c6 = Card(creationDate: Date.now, frontContent: "Front6", backContent: "Back6", interval: 1, dueDate: nil, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c7 = Card(creationDate: Date.now, frontContent: "Front7", backContent: "Back7", interval: 1, dueDate: nil, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        
        c4.status = .review
        c5.status = .review
        c6.status = .review
        c7.status = .learning
        
        try! persistentContainer.viewContext.save()
        
        // Fetch just one card
        var cards = flashCardService.getCards(in: deck1, withStatus: .new, withLimit: 1)
        XCTAssertEqual(cards.count, 1, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c0, "Unexpected card fetched")
        
        // Fetch 0 cards
        cards = flashCardService.getCards(in: deck1, withStatus: .new, withLimit: 0)
        XCTAssertEqual(cards.count, 0, "Unexpected number of cards, should be 0")
        
        // Fetch unlimited cards
        cards = flashCardService.getCards(in: deck1, withStatus: .learning, withLimit: nil)
        XCTAssertEqual(cards.count, 0, "Unexpected number of cards, should be 0")
        
        // Fetch 10 cards withStatus review
        cards = flashCardService.getCards(in: deck1, withStatus: .review, withLimit: 10)
        XCTAssertEqual(cards.count, 2, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c5, "Unexpected card fetched")
        XCTAssertEqual(cards[1], c6, "Unexpected card fetched")
        
        // Fetch unlimited new
        cards = flashCardService.getCards(in: deck1, withStatus: .new, withLimit: nil)
        XCTAssertEqual(cards.count, 1, "Unexpected number of cards")
        
        // Fetch unlimited review
        cards = flashCardService.getCards(in: deck1, withStatus: .review, withLimit: nil)
        XCTAssertEqual(cards.count, 2, "Unexpected number of cards")
        
        // Fetch unlimited learning
        cards = flashCardService.getCards(in: deck2, withStatus: .learning, withLimit: nil)
        XCTAssertEqual(cards.count, 1, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c7, "Unexpected card fetched")
        
        // Fetch unlimited new
        cards = flashCardService.getCards(in: deck2, withStatus: .new, withLimit: nil)
        XCTAssertEqual(cards.count, 3, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c1, "Unexpected card fetched")
        XCTAssertEqual(cards[1], c2, "Unexpected card fetched")
        XCTAssertEqual(cards[2], c3, "Unexpected card fetched")
    }
    
    func testGetCardsInDeckWithDueDate() {
        // Setup test data
        
        let deck1 = Deck(title: "Deck1", deckDescription: "AboutMyDeck", newCardsPerDay: 12, reviewCardsPerDay: 14, context: persistentContainer.viewContext)
        let deck2 = Deck(title: "Deck2", deckDescription: "This is a deck", newCardsPerDay: 44, reviewCardsPerDay: 55, context: persistentContainer.viewContext)
        let pack = ContentPack(title: "TITLE", packDescription: "DESC", author: "AUTH", context: persistentContainer.viewContext)
        
        let dueDate1 = Date.distantPast
        let dueDate2 = Date.now
        let dueDate3 = Date.distantFuture
        
        let c0 = Card(creationDate: Date.now, frontContent: "Front0", backContent: "Back0", interval: 1, dueDate: dueDate1, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c1 = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: dueDate1, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c2 = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: dueDate2, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c3 = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c4 = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: dueDate2, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c5 = Card(creationDate: Date.now, frontContent: "Front5", backContent: "Back5", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c6 = Card(creationDate: Date.now, frontContent: "Front6", backContent: "Back6", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        let c7 = Card(creationDate: Date.now, frontContent: "Front7", backContent: "Back7", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        
        try! persistentContainer.viewContext.save()
        
        // Fetch all cards
        var cards = flashCardService.getCards(in: deck1, withStatus: .new, withDueDate: dueDate2, withLimit: nil)
        XCTAssertEqual(cards.count, 3, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c0, "Unexpected card fetched")
        XCTAssertEqual(cards[1], c1, "Unexpected card fetched")
        XCTAssertEqual(cards[2], c2, "Unexpected card fetched")
        
        
        cards = flashCardService.getCards(in: deck2, withStatus: .new, withDueDate: dueDate2, withLimit: nil)
        
        XCTAssertEqual(cards.count, 1, "Unexpected number of cards")
        XCTAssertEqual(cards[0], c4, "Unexpected card fetched")
    }
    
    // MARK: - UPDATE
    
    
    func testUpdateContentPack() {
        
    }
    
    func testUpdateDeck() {
        
    }
    
    func testUpdateCardContent() {
        
    }
    
    func testUpdateCardStudyData() {
        
    }
    
    func testSet() {
        
    }
    
    func testAddCardToDeck() {
        
    }
    
    func testIncrementNewCardsStudiedRecently() {
        
    }
    
    func testIncrementReviewCardsStudiedRecently() {
        
    }
    
    func testResetStudyCounters() {
        
    }
    
    func testGetAvailableCardsFromContentPacks() {
        
    }
    
    func testAddRandomCardsToDeck() {
        
    }
    
    func testPerformUpdate() {
        
    }
    
    // MARK: - DELETE
    
    func testDeleteContentPack() {
        
    }
    
    func testDeleteDeck() {
        
    }
    
    func testDeleteCard() {
        
    }
}
