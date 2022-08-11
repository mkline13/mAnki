//
//  TestJig.swift
//  FlashCards
//
//  Created by Work on 8/9/22.
//

import CoreData
import UIKit


func loadTestJig() -> UIViewController {
//    studySessionTestJig()
    deckSettingsV2TestJig()
}

private func loadFlashCardServiceInMemory() -> FlashCardService {
    let bundle = Bundle(for: Card.self)
    let modelURL = bundle.url(forResource: "FlashCards", withExtension: "momd")!
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
    
    let container = PersistentContainerHelper.shared.createPersistentContainer(name: "FlashCards", managedObjectModel: managedObjectModel, shouldLoadStores: true)
    let flashCardService: FlashCardService = CoreDataFlashCardService(container: container)
    return flashCardService
}

private func studySessionTestJig() -> UIViewController {
    let flashCardService: FlashCardService = loadFlashCardServiceInMemory()
    
    let contentPack = flashCardService.newContentPack(title: "TestCollection", description: "TestCollection's Description", author: "Me")
    let deck = flashCardService.newDeck(title: "TestDeck", description: "TestDeck's Description", newCardsPerDay: 10, reviewCardsPerDay: 100)
    
    for i in 0...10 {
        let front = "\(i): Front of card #\(i)"
        let back = "\(i): Back of card #\(i)"
        _ = flashCardService.newCard(in: contentPack!, frontContent: front, backContent: back, deck: deck!)
    }
    
    let testJigViewController = try! StudySessionViewController(for: deck!, flashCardService: flashCardService)
    return testJigViewController
}

private func deckSettingsV2TestJig() -> UIViewController {
    let flashCardService: FlashCardService = loadFlashCardServiceInMemory()
    
    let deck = flashCardService.newDeck(title: "TestDeck", description: "TestDeck's Description", newCardsPerDay: 10, reviewCardsPerDay: 100)
    
    let p1 = flashCardService.newContentPack(title: "ABC", description: "TestCollection 1's Description", author: "Me")
    let p2 = flashCardService.newContentPack(title: "DEF", description: "TestCollection 2's Description", author: "You")
    let p3 = flashCardService.newContentPack(title: "AOIBNOIDBNOINB", description: "TestCollection 3's Description", author: "Us")
    let p4 = flashCardService.newContentPack(title: "TestCollec  on4", description: "TestCollection 4's Description", author: "We")
    
    deck!.addToAssociatedContentPacks(p1!)
    deck!.addToAssociatedContentPacks(p2!)
    deck!.addToAssociatedContentPacks(p3!)
    deck!.addToAssociatedContentPacks(p4!)
    
    let testJigViewController = DeckSettingsViewController(for: deck!, flashCardService: flashCardService)
    return testJigViewController
}
