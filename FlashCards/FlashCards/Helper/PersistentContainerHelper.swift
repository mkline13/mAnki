//
//  PersistentContainerHelper.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//

import CoreData
import Foundation

class PersistentContainerHelper {
    func createPersistentContainerWithInMemoryStores(name: String, managedObjectModel: NSManagedObjectModel) -> NSPersistentContainer {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.url = URL(fileURLWithPath: "/dev/null")
        storeDescription.shouldAddStoreAsynchronously = false

        let persistentContainer = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [storeDescription]

        return persistentContainer
    }
    
    func createPersistentContainerWithOnDiskStores(name: String, managedObjectModel: NSManagedObjectModel) -> NSPersistentContainer {
        let persistentContainer = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
        
        return persistentContainer
    }
    
    private func destroyPersistentStoresOnDisk(persistentContainer: NSPersistentContainer) {
        for storeDescription in persistentContainer.persistentStoreDescriptions {
            guard let url = storeDescription.url else{
                continue
            }
            
            do {
                try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
            }
            catch {
                fatalError("Could not delete persistent stores")
            }
        }
    }

    // MARK: Properties
    static let shared = PersistentContainerHelper()
}
