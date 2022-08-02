//
//  CoreDataFlashCardServiceTests.swift
//  FlashCardsTests
//
//  Created by Work on 8/1/22.
//


import XCTest
@testable import FlashCards
import CoreData


class CoreDataFlashCardServiceTests: XCTestCase {
    func testInitializer() {
        let container = PersistentContainerHelper.shared.createPersistentContainer()
        let service = CoreDataFlashCardService(container: container)
        
        XCTAssertEqual(service.container, container)
    }
}
