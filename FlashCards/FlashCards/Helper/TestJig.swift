//
//  TestJig.swift
//  FlashCards
//
//  Created by Work on 8/9/22.
//

import CoreData
import UIKit


func loadTestJig() -> UIViewController {
    studySessionTestJig()
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

private func studySessionLauncherTestJig() -> UIViewController {
    let dependencyContainer = DependencyContainer(storesInMemory: true)
    let flashCardService = dependencyContainer.flashCardService
    
    let deck = flashCardService.newDeck(title: "TestDeck", description: "TestDeck's Description", newCardsPerDay: 10, reviewCardsPerDay: 100)
    
    let p1 = flashCardService.newContentPack(title: "ABC", description: "TestCollection 1's Description", author: "Me")
    let p2 = flashCardService.newContentPack(title: "DEF", description: "TestCollection 2's Description", author: "You")
    let p3 = flashCardService.newContentPack(title: "AOIBNOIDBNOINB", description: "TestCollection 3's Description", author: "Us")
    let p4 = flashCardService.newContentPack(title: "TestCollec  on4", description: "TestCollection 4's Description", author: "We")
    
    deck!.addToAssociatedContentPacks(p1!)
    deck!.addToAssociatedContentPacks(p2!)
    deck!.addToAssociatedContentPacks(p3!)
    deck!.addToAssociatedContentPacks(p4!)
    
    let testJigViewController = StudySessionLauncherViewController(for: deck!, dependencyContainer: dependencyContainer)
    return testJigViewController
}

private func studySessionTestJig() -> UIViewController {
    let dependencyContainer = DependencyContainer(storesInMemory: true)
    let flashCardService = dependencyContainer.flashCardService
    
    let deck = flashCardService.newDeck(title: "TestDeck", description: "TestDeck's Description", newCardsPerDay: 10, reviewCardsPerDay: 100)
    let pack = flashCardService.newContentPack(title: "ABC", description: "TestCollection 1's Description", author: "Me")
    
    let cards = [
        flashCardService.newCard(in: pack!, frontContent: "FRONT CONTENT 1", backContent: "BACK CONTENT 1", deck: deck)!,
        flashCardService.newCard(in: pack!, frontContent: "FRONT CONTENT 2", backContent: "BACK CONTENT 2", deck: deck)!,
        flashCardService.newCard(in: pack!, frontContent: "FRONT CONTENT 2", backContent: "BACK CONTENT 2", deck: deck)!,
    ]
    
    let testJigViewController = try! StudySessionViewController(cards: cards, dependencyContainer: dependencyContainer)
    return testJigViewController
}
