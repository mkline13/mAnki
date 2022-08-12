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
    let dependencyContainer = DependencyContainer(storesInMemory: true)
    return dependencyContainer.flashCardService
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
