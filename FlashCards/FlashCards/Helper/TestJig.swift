//
//  TestJig.swift
//  FlashCards
//
//  Created by Work on 8/9/22.
//

import CoreData
import UIKit


func loadTestJig() -> UIViewController {
    let bundle = Bundle(for: Card.self)
    let modelURL = bundle.url(forResource: "FlashCards", withExtension: "momd")!
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
    
    let container = PersistentContainerHelper.shared.createPersistentContainer(name: "FlashCards", managedObjectModel: managedObjectModel, shouldLoadStores: true)
    let flashCardService: FlashCardService = CoreDataFlashCardService(container: container)
    
    let contentPack = flashCardService.newContentPack(title: "TestCollection", description: "TestCollection's Description", author: "Me")
    let deck = flashCardService.newDeck(title: "TestDeck", description: "TestDeck's Description", newCardsPerDay: 10, reviewCardsPerDay: 100)
    
    for i in 0...10 {
        let front = "\(i): Front of card #\(i)"
        let back = "\(i): Back of card #\(i)"
        _ = flashCardService.newCard(in: contentPack!, frontContent: front, backContent: back, deck: deck!)
    }
    
    let testJigViewController = StudySessionViewController(for: deck!, flashCardService: flashCardService)
    return testJigViewController
}
