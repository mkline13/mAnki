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
    
    // MARK: Service
    func newContentPack(withTitle title: String, packDescription description: String = "", author: String = "") -> ContentPack? {
        let pack = ContentPack(title: title, packDescription: description, author: author, context: persistentContainer.viewContext)
        saveViewContext()
        return pack
    }
    
    func newCard(in pack: ContentPack, frontContent front: String = "", backContent back: String = "", deck: Deck? = nil) -> Card? {
        let card = Card(frontContent: front, backContent: back, contentPack: pack, deck: deck, context: persistentContainer.viewContext)
        saveViewContext()
        return card
    }
    
    func delete(_ contentPack: ContentPack) {
        persistentContainer.viewContext.delete(contentPack)
        saveViewContext()
    }
    
    func delete(_ card: Card) {
        persistentContainer.viewContext.delete(card)
        saveViewContext()
    }
    
    func contentPackResultsController(with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<ContentPack>? {
        let fetchRequest:NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ContentPack.title, ascending: true)]
        return  createResultsController(for: delegate, fetchRequest: fetchRequest)
    }
    
    private func createResultsController<T>(for delegate: NSFetchedResultsControllerDelegate, fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>? where T: NSFetchRequestResult {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate
        
        guard let _ = try? resultsController.performFetch() else {
            return nil
        }
        
        return resultsController
    }
    
    // MARK: Helpers
    private func saveViewContext() {
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            print("Failed to save viewContext, rolling back")
            persistentContainer.viewContext.rollback()
        }
    }
}
