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
        _ = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck1, context: persistentContainer.viewContext)
        let c4 = Card(creationDate: Date.now, frontContent: "Front4", backContent: "Back4", interval: 1, dueDate: dueDate2, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front5", backContent: "Back5", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front6", backContent: "Back6", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        _ = Card(creationDate: Date.now, frontContent: "Front7", backContent: "Back7", interval: 1, dueDate: dueDate3, contentPack: pack, deck: deck2, context: persistentContainer.viewContext)
        
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
    
    func testGetAvailableCardsFromContentPacks() {
        // Set up
        
        let associatedPack = ContentPack(title: "Associated Pack", packDescription: "It's associated with a deck", author: "Me", context: persistentContainer.viewContext)
        let notAssociatedPack = ContentPack(title: "Just a pack", packDescription: "It's not associated with a deck", author: "Me", context: persistentContainer.viewContext)
        let deck = Deck(title: "Deck", deckDescription: "Deck Desc", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)
        deck.associatedContentPacks = NSSet(array: [associatedPack])
        
        let date = Date.now
        let c0 = Card(creationDate: date, frontContent: "Front 0 (associated)", backContent: "Back 0 (associated)", interval: 1, dueDate: nil, contentPack: associatedPack, deck: nil, context: persistentContainer.viewContext)
        let c1 = Card(creationDate: date, frontContent: "Front 1 (associated)", backContent: "Back 1 (associated)", interval: 1, dueDate: nil, contentPack: associatedPack, deck: nil, context: persistentContainer.viewContext)
        let c2 = Card(creationDate: date, frontContent: "Front 2 (associated)", backContent: "Back 2 (associated)", interval: 1, dueDate: nil, contentPack: associatedPack, deck: nil, context: persistentContainer.viewContext)
        let c3 = Card(creationDate: date, frontContent: "Front 3 (associated)", backContent: "Back 3 (associated)", interval: 1, dueDate: nil, contentPack: associatedPack, deck: nil, context: persistentContainer.viewContext)
        let c4 = Card(creationDate: date, frontContent: "Front 3 (associated)", backContent: "Back 3 (associated)", interval: 1, dueDate: nil, contentPack: associatedPack, deck: deck, context: persistentContainer.viewContext)
        
        let c5 = Card(creationDate: date, frontContent: "Front 4 (not associated)", backContent: "Back 4 (not associated)", interval: 1, dueDate: nil, contentPack: notAssociatedPack, deck: nil, context: persistentContainer.viewContext)
        let c6 = Card(creationDate: date, frontContent: "Front 5 (not associated)", backContent: "Back 5 (not associated)", interval: 1, dueDate: nil, contentPack: notAssociatedPack, deck: nil, context: persistentContainer.viewContext)
        let c7 = Card(creationDate: date, frontContent: "Front 6 (not associated)", backContent: "Back 6 (not associated)", interval: 1, dueDate: nil, contentPack: notAssociatedPack, deck: nil, context: persistentContainer.viewContext)
        let c8 = Card(creationDate: date, frontContent: "Front 7 (not associated)", backContent: "Back 7 (not associated)", interval: 1, dueDate: nil, contentPack: notAssociatedPack, deck: nil, context: persistentContainer.viewContext)
        let c9 = Card(creationDate: date, frontContent: "Front 8 (not associated)", backContent: "Back 8 (not associated)", interval: 1, dueDate: nil, contentPack: notAssociatedPack, deck: deck, context: persistentContainer.viewContext)

        try! persistentContainer.viewContext.save()
        
        // Test
        let context = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(keyPath: \Deck.title, ascending: true) ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", deck)
        
        context.performAndWait {
            guard let fetchedDeck = (try? context.fetch(fetchRequest))?.first as? Deck else {
                XCTFail("Could not fetch created deck")
                return
            }
            
            XCTAssert(fetchedDeck.cards.count == 2, "Unexpected number of cards in deck")
            XCTAssert(fetchedDeck.associatedContentPacks.count == 1, "Unexpected number of associated content packs")
        }
        
        let cards = flashCardService.getAvailableCardsFromContentPacks(for: deck)
        XCTAssertEqual(cards.count, 4, "Unexpected number of cards")
        XCTAssert(cards.contains(c0), "Unexpected card found in result")
        XCTAssert(cards.contains(c1), "Unexpected card found in result")
        XCTAssert(cards.contains(c2), "Unexpected card found in result")
        XCTAssert(cards.contains(c3), "Unexpected card found in result")
        
        XCTAssert(!cards.contains(c4), "Unexpected card found in result")
        XCTAssert(!cards.contains(c5), "Unexpected card found in result")
        XCTAssert(!cards.contains(c6), "Unexpected card found in result")
        XCTAssert(!cards.contains(c7), "Unexpected card found in result")
        XCTAssert(!cards.contains(c8), "Unexpected card found in result")
        XCTAssert(!cards.contains(c9), "Unexpected card found in result")
    }
    
    // MARK: - UPDATE
    
    
    func testUpdateContentPack() {
        // Setup
        let pack = ContentPack(title: "Sup", packDescription: "Supsup", author: "Peter Supman", context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Test
        flashCardService.updateContentPack(pack, title: "NEW TITLE", description: "new description", author: "It's a new me")
        
        // Check storage
        let fetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \ContentPack.title, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", pack)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedPacks = try? context.fetch(fetchRequest) else {
                XCTFail("Could not fetch created content pack")
                return
            }
            guard let fetchedPack: ContentPack = fetchedPacks.first else {
                XCTFail("No packs in fetch result")
                return
            }
            
            XCTAssertEqual(fetchedPack.title, pack.title)
            XCTAssertEqual(fetchedPack.packDescription, pack.packDescription)
            XCTAssertEqual(fetchedPack.author, pack.author)
        }
    }
    
    func testUpdateDeck() {
        // Setup
        let deck = Deck(title: "old title", deckDescription: "old desc", newCardsPerDay: 10, reviewCardsPerDay: 20, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()
        
        // Test
        flashCardService.updateDeck(deck, title: "new title", description: "new desc", newCardsPerDay: 33, reviewCardsPerDay: 44)
        
        // Check storage
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Deck.title, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", deck)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedDecks = try? context.fetch(fetchRequest) else {
                XCTFail("Could not fetch created content pack")
                return
            }
            guard let fetchedDeck: Deck = fetchedDecks.first else {
                XCTFail("No packs in fetch result")
                return
            }
            
            XCTAssertEqual(fetchedDeck.title, deck.title)
            XCTAssertEqual(fetchedDeck.deckDescription, deck.deckDescription)
            XCTAssertEqual(fetchedDeck.dailyNewCardLimit, deck.dailyNewCardLimit)
            XCTAssertEqual(fetchedDeck.dailyReviewCardLimit, deck.dailyReviewCardLimit)
        }
    }
    
    func testUpdateCardContent() {
        // Setup
        let date = Date.now
        let pack = ContentPack(title: "Sup", packDescription: "Supsup", author: "Peter Supman", context: persistentContainer.viewContext)
        let card = Card(creationDate: date, frontContent: "front", backContent: "back", interval: 22, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        
        // Test
        flashCardService.updateCard(card, frontContent: "NEW FRONT", backContent: "NEW BACK")
        
        // Check storage
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", card)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedObjects = try? context.fetch(fetchRequest) else {
                XCTFail("Could not fetch created objects")
                return
            }
            
            guard let fetchedCard = fetchedObjects.first else {
                XCTFail("No packs in fetched results")
                return
            }
            
            XCTAssertEqual(fetchedCard.frontContent, card.frontContent)
            XCTAssertEqual(fetchedCard.backContent, card.backContent)
        }
    }
    
    func testUpdateCardStudyData() {
        // Setup
        let date = Date.now
        let pack = ContentPack(title: "Sup", packDescription: "Supsup", author: "Peter Supman", context: persistentContainer.viewContext)
        let card = Card(creationDate: date, frontContent: "front", backContent: "back", interval: 22, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        
        try! persistentContainer.viewContext.save()
        
        // Test
        flashCardService.updateCard(card, interval: 66, dueDate: date, status: .review)
        
        // Check storage
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", card)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedObjects = try? context.fetch(fetchRequest) else {
                XCTFail("Could not fetch created objects")
                return
            }
            
            guard let fetchedCard = fetchedObjects.first else {
                XCTFail("No packs in fetched results")
                return
            }
            
            XCTAssertEqual(fetchedCard.srsInterval, card.srsInterval)
            XCTAssertEqual(fetchedCard.srsDueDate, card.srsDueDate)
            XCTAssertEqual(fetchedCard.studyStatus, card.studyStatus)
        }
    }
    
    func testSetContentPacksForDeck() {
        // Setup
        let pack1 = ContentPack(title: "p1", packDescription: "p1desc", author: "p1auth", context: persistentContainer.viewContext)
        let pack2 = ContentPack(title: "p2", packDescription: "p2desc", author: "p2auth", context: persistentContainer.viewContext)
        let pack3 = ContentPack(title: "p3", packDescription: "p3desc", author: "p3auth", context: persistentContainer.viewContext)
        let pack4 = ContentPack(title: "p4", packDescription: "p4desc", author: "p4auth", context: persistentContainer.viewContext)

        let deck = Deck(title: "Test Deck", deckDescription: "It's a test", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)
        try! persistentContainer.viewContext.save()

        let packs1 = Set([pack1, pack2])
        let packs2 = Set([pack3, pack4])
        
        // Test
        flashCardService.set(contentPacks: packs1, for: deck)
        
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Deck.title, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", deck)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedDeck: Deck = (try? context.fetch(fetchRequest))?.first else {
                XCTFail("Could not fetch stored deck")
                return
            }
                        
            for p in packs1 {
                XCTAssert(fetchedDeck.associatedContentPacks.contains(where: { item in (item as! NSManagedObject).objectID == p.objectID }), "Couldn't find object ID")
            }
        }
        
        flashCardService.set(contentPacks: packs2, for: deck)
        context.performAndWait {
            guard let fetchedDeck: Deck = (try? context.fetch(fetchRequest))?.first else {
                XCTFail("Could not fetch stored deck")
                return
            }
                        
            for p in packs2 {
                XCTAssert(fetchedDeck.associatedContentPacks.contains(where: { item in (item as! NSManagedObject).objectID == p.objectID }), "Couldn't find object ID")
            }
        }
    }
    
    func testAddCardsToDeck() {
        // Setup
        let pack = ContentPack(title: "Sup", packDescription: "Supsup", author: "Peter Supman", context: persistentContainer.viewContext)
        
        let c0 = Card(creationDate: Date.now, frontContent: "Front0", backContent: "Back0", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c1 = Card(creationDate: Date.now, frontContent: "Front1", backContent: "Back1", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c2 = Card(creationDate: Date.now, frontContent: "Front2", backContent: "Back2", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        let c3 = Card(creationDate: Date.now, frontContent: "Front3", backContent: "Back3", interval: 1, dueDate: nil, contentPack: pack, deck: nil, context: persistentContainer.viewContext)
        
        let deck = Deck(title: "Test Deck", deckDescription: "It's a test", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)

        // Test
        flashCardService.add(cards: [c0, c1, c2, c3], to: deck)
        
        // Check storage
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.frontContent, ascending: true) ]
        fetchRequest.predicate = NSPredicate(format: "deck == %@", deck)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedCards = try? context.fetch(fetchRequest) else {
                XCTFail("Could not fetch stored cards")
                return
            }
            
            XCTAssert(fetchedCards.count == 4, "Unexpected number of cards")
            XCTAssert(fetchedCards[0].objectID == c0.objectID)
            XCTAssert(fetchedCards[1].objectID == c1.objectID)
            XCTAssert(fetchedCards[2].objectID == c2.objectID)
            XCTAssert(fetchedCards[3].objectID == c3.objectID)
        }
    }
    
    func testIncrementNewAndReviewCardsStudiedTodayAndResetCounters() {
        // Setup
        let deck = Deck(title: "Test Deck", deckDescription: "It's a test", newCardsPerDay: 22, reviewCardsPerDay: 33, context: persistentContainer.viewContext)
        let newCardsStudiedToday = deck.newCardsStudiedToday
        let reviewCardsStudiedToday = deck.reviewCardsStudiedToday
        
        try! persistentContainer.viewContext.save()
        
        // Test
        flashCardService.incrementNewCardsStudiedToday(for: deck)
        
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Deck.title, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", deck)
        
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedDeck: Deck = (try? context.fetch(fetchRequest))?.first else {
                XCTFail("Could not fetch stored deck")
                return
            }
            XCTAssert(fetchedDeck.newCardsStudiedToday == newCardsStudiedToday + 1, "Unexpected value of newCardsStudiedToday")
        }
        
        flashCardService.incrementReviewCardsStudiedToday(for: deck)
        context.performAndWait {
            guard let fetchedDeck: Deck = (try? context.fetch(fetchRequest))?.first else {
                XCTFail("Could not fetch stored deck")
                return
            }
            XCTAssert(fetchedDeck.reviewCardsStudiedToday == reviewCardsStudiedToday + 1, "Unexpected value of reviewCardsStudiedToday")
        }
        
        flashCardService.resetStudyCounters(for: deck)
        context.performAndWait {
            guard let fetchedDeck: Deck = (try? context.fetch(fetchRequest))?.first else {
                XCTFail("Could not fetch stored deck")
                return
            }
            XCTAssert(fetchedDeck.newCardsStudiedToday == 0, "Unexpected value of newCardsStudiedToday")
            XCTAssert(fetchedDeck.reviewCardsStudiedToday == 0, "Unexpected value of reviewCardsStudiedToday")
        }
        
    }
    
    func testAddRandomCardsToDeck() {
        // setup
        // test quantity 0
        // test that the appropriate amount were added to the deck
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
