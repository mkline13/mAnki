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
//    func createStudyRecord() -> StudyRecord?
    
    // MARK: READ
    func contentPackResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ContentPack>?
    func deckResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Deck>?
    
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Card>?
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for deck: Deck) -> NSFetchedResultsController<Card>?
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for pack: ContentPack) -> NSFetchedResultsController<Card>?
    
    // MARK: UPDATE
    func updateContentPack(_ pack: ContentPack, title: String, description pdesc: String, author: String)
    func updateDeck(_ deck: Deck, title: String, description ddesc: String, newCardsPerDay ncpd: Int64, reviewCardsPerDay rcpd: Int64)
    func updateCard(_ card: Card, frontContent front: String, backContent back: String)
    
    // MARK: DELETE
    func delete(_ contentPack: ContentPack)
    func delete(_ deck: Deck)
    func delete(_ card: Card)
    
    // MARK: Helpers
    func loadTestData()
    func printDecks()
    func printDecks(_ msg: String)
}
