//
//  FlashCardService.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData


protocol FlashCardService {
    // MARK: Initializers
    init(container: NSPersistentContainer)
    
    // MARK: CREATE
    func newContentPack(title: String, description pdesc: String, author: String) -> ContentPack?
    func newDeck(title: String, description ddesc: String, newCardsPerDay ncpd: Int64, reviewCardsPerDay rcpd: Int64) -> Deck?
    func newCard(in: ContentPack, frontContent front: String, backContent back: String, deck: Deck?) -> Card?
    func createStudyRecord(for card: Card, studyStatus: StudyResult, afterInterval: Int64) -> StudyRecord?
    
    // MARK: READ
    func contentPackResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ContentPack>?
    func deckResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Deck>?
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Card>?
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for deck: Deck) -> NSFetchedResultsController<Card>?
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for pack: ContentPack) -> NSFetchedResultsController<Card>?
    func getDecks() -> [Deck]
    func getCards() -> [Card]
    
    func getCards(in deck: Deck, withStatus status: Card.Status, withLimit limit: Int?) -> [Card]
    func getCards(in deck: Deck, withStatus status: Card.Status, withDueDate date: Date, withLimit limit: Int?) -> [Card]
    
    // MARK: UPDATE
    func updateContentPack(_ pack: ContentPack, title: String, description pdesc: String, author: String)
    func updateDeck(_ deck: Deck, title: String, description ddesc: String, newCardsPerDay ncpd: Int64, reviewCardsPerDay rcpd: Int64)
    func updateCard(_ card: Card, frontContent front: String, backContent back: String)
    func updateCard(_ card: Card, interval: Int64, dueDate: Date, status: Card.Status)
    
    func set(contentPacks: Set<ContentPack>, for deck: Deck)
    func add(cards: [Card], to: Deck)
    
    func incrementNewCardsStudiedToday(for deck: Deck)
    func incrementReviewCardsStudiedToday(for deck: Deck)
    func resetStudyCounters(for deck: Deck)
    
    func getAvailableCardsFromContentPacks(for deck: Deck) -> [Card]
    func add(randomCards cards: [Card], to deck: Deck, quantity: Int)
    
    func performUpdate(handler: @escaping () -> Void)
    
    // MARK: DELETE
    func delete(_ contentPack: ContentPack)
    func delete(_ deck: Deck)
    func delete(_ card: Card)
    
    // MARK: Helpers
    func printDecks(_ msg: String)
    func printStudyRecords(for deck: Deck, withMessage: String)
}
