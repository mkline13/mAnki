//
//  DependencyContainer.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData

class DependencyContainer {
    init(creationMethod: PersistentContainerCreator) {
        let bundle = Bundle(for: Card.self)
        let name = "FlashCards"
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        

        persistentContainer = creationMethod(name, managedObjectModel)
        
        persistentContainer.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
        
        flashCardService = CoreDataFlashCardService(container: persistentContainer)
        srsService = SRSService()
    }
    
    let persistentContainer: NSPersistentContainer
    let flashCardService: FlashCardService
    let srsService: SRSService
    
    typealias PersistentContainerCreator = (String, NSManagedObjectModel) -> NSPersistentContainer
}
