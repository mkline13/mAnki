//
//  DependencyContainer.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData


class DependencyContainer {
    private init() {
        let bundle = Bundle(for: Card.self)
        let    modelURL = bundle.url(forResource: "FlashCards", withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!

        persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
        
        flashCardService = CoreDataFlashCardService(container: persistentContainer)
    }

    let managedObjectModel: NSManagedObjectModel
    let persistentContainer: NSPersistentContainer
    let flashCardService: FlashCardService

    static let shared = DependencyContainer()
}

