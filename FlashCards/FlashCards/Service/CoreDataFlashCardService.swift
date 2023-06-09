//
//  CoreDataFlashCardService.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData


class CoreDataFlashCardService: FlashCardService {
    // MARK: Dependencies
    let persistentContainer: NSPersistentContainer
    
    // MARK: Initializers
    required init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    // MARK: - CREATE
    func newContentPack(title: String, description packDescription: String, author: String) -> ContentPack? {
        let pack = ContentPack(title: title, packDescription: packDescription, author: author, context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.obtainPermanentIDs(for: [pack])
        }
        catch {
            print("Could not obtain permanent ID for pack: '\(pack.title)'")
        }
        
        saveViewContext()
        return pack
    }
    
    func newCard(in pack: ContentPack, frontContent front: String, backContent back: String, deck: Deck? = nil) -> Card? {
        let card = Card(creationDate: Date.now, frontContent: front, backContent: back, interval: 0, dueDate: nil, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.obtainPermanentIDs(for: [card])
        }
        catch {
            print("Could not obtain permanent ID for card: '\(card.frontContent)'")
        }
        
        saveViewContext()
        return card
    }
    
    func newDeck(title: String, description ddesc: String = "", newCardsPerDay ncpd: Int64, reviewCardsPerDay rcpd: Int64) -> Deck? {
        let deck = Deck(title: title, deckDescription: ddesc, newCardsPerDay: ncpd, reviewCardsPerDay: rcpd, context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.obtainPermanentIDs(for: [deck])
        }
        catch {
            print("Could not obtain permanent ID for pack: '\(deck.title)'")
        }
        
        saveViewContext()
        return deck
    }
    
    func createStudyRecord(for card: Card, studyStatus: StudyResult, afterInterval: Int64) -> StudyRecord? {
        let studyRecord = StudyRecord(timestamp: Date.now, studyStatus: studyStatus, afterInterval: afterInterval, card: card, context: persistentContainer.viewContext)
        saveViewContext()
        return studyRecord
    }
    
    // MARK: - READ
    func contentPackResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ContentPack>? {
        let fetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ContentPack.title, ascending: true)]
        return  createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    func deckResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Deck>? {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        return  createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Card>? {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.deck, ascending: true),
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true),
        ]
        return createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for deck: Deck) -> NSFetchedResultsController<Card>? {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true),
        ]
        
        fetchRequest.predicate = NSPredicate(format: "deck == %@", deck)
        return createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    func cardResultsController(with delegate: NSFetchedResultsControllerDelegate, for pack: ContentPack) -> NSFetchedResultsController<Card>? {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true),
        ]
        fetchRequest.predicate = NSPredicate(format: "contentPack == %@", pack)
        return createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    private func createResultsController<T>(for delegate: NSFetchedResultsControllerDelegate, fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: persistentContainer.viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        resultsController.delegate = delegate
        
        guard let _ = try? resultsController.performFetch() else {
            print("Could not fetch items")
            return nil
        }
        
        return resultsController
    }
    
    func getDecks() -> [Deck] {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Deck.title, ascending: true)
        ]
        
        do {
            let decks = try persistentContainer.viewContext.fetch(fetchRequest)
            return decks
        }
        catch {
            fatalError("Could not fetch decks.")
        }
    }
    
    func getCards() -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]
        
        do {
            let cards = try persistentContainer.viewContext.fetch(fetchRequest)
            return cards
        }
        catch {
            fatalError("Could not fetch cards.")
        }
    }
    
    
    func getCards(in deck: Deck, withStatus status: Card.Status, withLimit limit: Int? = nil) -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        if let limit = limit {
            guard limit > 0 else {
                return []
            }
            fetchRequest.fetchLimit = limit
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]

        fetchRequest.predicate = NSPredicate(format: "(deck == %@) AND (studyStatus == %ld)", deck, status.rawValue)
        
        do {
            let cards = try persistentContainer.viewContext.fetch(fetchRequest)
            return cards
        }
        catch {
            fatalError("Could not fetch cards.")
        }
    }
    
    func getCards(in deck: Deck, withStatus status: Card.Status, withDueDate date: Date, withLimit limit: Int? = nil) -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        if let limit = limit {
            guard limit > 0 else {
                return []
            }
            fetchRequest.fetchLimit = limit
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]

        fetchRequest.predicate = NSPredicate(format: "(deck == %@) AND (studyStatus == %ld) AND (srsDueDate <= %@)", deck, status.rawValue, date as CVarArg)
        
        do {
            let cards = try persistentContainer.viewContext.fetch(fetchRequest)
            return cards
        }
        catch {
            fatalError("Could not fetch cards.")
        }
    }
    
    func getAvailableCardsFromContentPacks(for deck: Deck) -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Card.frontContent, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "(deck = nil)")
        
        let availableCards: [Card]
        do {
            let fetchedCards = try persistentContainer.viewContext.fetch(fetchRequest)
            availableCards = fetchedCards.filter({ deck.associatedContentPacks.contains($0.contentPack) })
        }
        catch {
            fatalError("Could not fetch cards.")
        }
        
        return availableCards
    }
    
        
    // MARK: - UPDATE
    func updateContentPack(_ pack: ContentPack, title: String, description pdesc: String, author: String) {
        pack.title = title
        pack.packDescription = pdesc
        pack.author = author
        saveViewContext()
    }
    
    func updateDeck(_ deck: Deck, title: String, description ddesc: String, newCardsPerDay ncpd: Int64, reviewCardsPerDay rcpd: Int64) {
        deck.title = title
        deck.deckDescription = ddesc
        deck.dailyNewCardLimit = ncpd
        deck.dailyReviewCardLimit = rcpd
        saveViewContext()
    }
    
    func updateCard(_ card: Card, frontContent front: String, backContent back: String) {
        card.frontContent = front
        card.backContent = back
        saveViewContext()
    }
    
    func updateCard(_ card: Card, interval: Int64, dueDate: Date, status: Card.Status) {
        card.srsInterval = interval
        card.srsDueDate = dueDate
        card.status = status
        
        saveViewContext()
    }
    
    func set(contentPacks: Set<ContentPack>, for deck: Deck) {
        deck.associatedContentPacks = contentPacks as NSSet
        saveViewContext()
    }
    
    func add(cards: [Card], to deck: Deck) {
        deck.addToCards(NSSet(array: cards))
        saveViewContext()
    }
    
    func incrementNewCardsStudiedToday(for deck: Deck) {
        deck.newCardsStudiedToday += 1
        saveViewContext()
    }
    
    func incrementReviewCardsStudiedToday(for deck: Deck) {
        deck.reviewCardsStudiedToday += 1
        saveViewContext()
    }
    
    func resetStudyCounters(for deck: Deck) {
        deck.newCardsStudiedToday = 0
        deck.reviewCardsStudiedToday = 0
        saveViewContext()
    }
    
    func add(randomCards cards: [Card], to deck: Deck, quantity: Int) {
        guard quantity > 0 else {
            return
        }
        
        var cards = cards
        
        for _ in 0..<quantity {
            guard let randomIndex = cards.indices.randomElement() else {
                break
            }
            
            let card = cards.remove(at: randomIndex)
            deck.addToCards(card)
        }
        
        saveViewContext()
    }
    
    func performUpdate(handler: @escaping () -> Void) {
        handler()
        saveViewContext()
    }
    
    // MARK: - DELETE
    func delete(_ contentPack: ContentPack) {
        persistentContainer.viewContext.delete(contentPack)
        saveViewContext()
    }
    
    func delete(_ deck: Deck) {
        persistentContainer.viewContext.delete(deck)
        saveViewContext()
    }
    
    func delete(_ card: Card) {
        persistentContainer.viewContext.delete(card)
        saveViewContext()
    }
    
    // MARK: - Helpers
    private func saveViewContext() {
        do {
            try persistentContainer.viewContext.save()
            
        }
        catch {
            print("Failed to save viewContext, rolling back")
            persistentContainer.viewContext.rollback()
        }
    }
    
    func printDecks(_ msg: String = "") {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        
        guard let results = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            print("Could not print decks: results was nil")
            return
        }
        
        print("Decks: \(msg)")
        for (index, deck) in results.enumerated() {
            print("  - \(index): \(deck.title)")
        }
        
    }
    
    func printStudyRecords(for deck: Deck, withMessage msg: String) {
        let fetchRequest: NSFetchRequest<StudyRecord> = StudyRecord.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \StudyRecord.timestamp, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "card.deck == %@", deck)
        
        guard let results = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            print("Could not print study records: results was nil")
            return
        }
        
        guard results.count > 0 else {
            print("Study Records: \(msg)")
            print("  (none)")
            return
        }
        
        print("Study Records: \(msg)")
        for record in results {
            let timestamp = record.timestamp.formatted(date: .numeric, time: .standard)
            let frontContent = record.card.frontContent.prefix(10)
            print("  - \(timestamp), '\(frontContent)', \(record.studyStatus), afterInterval: \(record.afterInterval)")
        }
    }
}
