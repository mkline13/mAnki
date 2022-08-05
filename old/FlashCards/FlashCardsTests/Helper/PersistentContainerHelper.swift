//
//  PersistentContainerHelper.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//

import CoreData
import Foundation
@testable import FlashCards


class PersistentContainerHelper {
    func createPersistentContainer(shouldLoadStores: Bool = true) -> NSPersistentContainer {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        storeDescription.shouldAddStoreAsynchronously = false

        let persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: DependencyContainer.shared.managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [storeDescription]

        if shouldLoadStores {
            persistentContainer.loadPersistentStores { _, error in
                guard error == nil else {
                    fatalError("Failed to load persistent stores for in memory persistent container: \(error!)")
                }
            }
        }

        return persistentContainer
    }

    // MARK: Properties
    static let shared = PersistentContainerHelper()
}
