//
//  DependencyContainer.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData

class DependencyContainer {
    init(storesInMemory: Bool = false) {
        let bundle = Bundle(for: Card.self)
        let name = "FlashCards"
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentContainer: NSPersistentContainer
        
        if storesInMemory {
            persistentContainer = PersistentContainerHelper.shared.createPersistentContainerWithInMemoryStores(name: name, managedObjectModel: managedObjectModel)
        }
        else {
            persistentContainer = PersistentContainerHelper.shared.createPersistentContainerWithOnDiskStores(name: name, managedObjectModel: managedObjectModel)
        }
        
        persistentContainer.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
        
        flashCardService = CoreDataFlashCardService(container: persistentContainer)
    }
    
    let flashCardService: FlashCardService
}
