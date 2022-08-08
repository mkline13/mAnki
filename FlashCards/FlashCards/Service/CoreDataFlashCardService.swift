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
        let card = Card(frontContent: front, backContent: back, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        
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
        let deck = Deck(title: title, deckDescription: ddesc, newCardsPerDay: ncpd, reviewCardsLimit: rcpd, context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.obtainPermanentIDs(for: [deck])
        }
        catch {
            print("Could not obtain permanent ID for pack: '\(deck.title)'")
        }
        
        saveViewContext()
        return deck
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
    
    private func createResultsController<T>(for delegate: NSFetchedResultsControllerDelegate, fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: persistentContainer.viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: "cache")
        resultsController.delegate = delegate
        
        guard let _ = try? resultsController.performFetch() else {
            print("Could not fetch items")
            return nil
        }
        
        return resultsController
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
        deck.newCardsPerDay = ncpd
        deck.reviewCardsLimit = rcpd
        saveViewContext()
    }
    
    func updateCard(_ card: Card, frontContent front: String, backContent back: String) {
        card.frontContent = front
        card.backContent = back
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
    
    func printDecks() {
        printDecks("")
    }
    
    func printDecks(_ msg: String) {
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
    
    func loadTestData() {
        // Create pack, deck, and cards
        let contentPackFetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        let contentPackCount = try! persistentContainer.viewContext.count(for: contentPackFetchRequest)
        if contentPackCount == 0 {
            guard let pack = self.newContentPack(title: "TestPack", description: "", author: "") else {
                fatalError("Could not create TestPack")
            }
            
            guard let deck = self.newDeck(title: "TestDeck", newCardsPerDay: 10, reviewCardsPerDay: 10) else {
                fatalError("Could not create TestDeck")
            }
            
            for i in 0...4 {
                
                var text = "Wo"
                for _ in 0...i {
                    text = text + "wee"
                }
                
                _ = self.newCard(in: pack, frontContent: text, backContent: String(text.reversed()), deck: deck)
            }
            
            print("Loaded Test Data")
        }
        else {
            let deckFetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
            let deckCount = try! persistentContainer.viewContext.count(for: deckFetchRequest)
            if deckCount == 0 {
                guard let _ = self.newDeck(title: "TestDeck", newCardsPerDay: 10, reviewCardsPerDay: 10) else {
                    fatalError("Could not create TestDeck")
                }
            }
        }
        
        let studyRecordsFetchRequest: NSFetchRequest<StudyRecord> = StudyRecord.fetchRequest()
        if try! persistentContainer.viewContext.count(for: studyRecordsFetchRequest) == 0 {
            // TODO: study record adder
        }
    }
}
