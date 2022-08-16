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
    // MARK: Properties
    static var dependencyContainer: DependencyContainer!
    var persistentContainer: NSPersistentContainer!
    var flashCardService: FlashCardService!

    override class func setUp() {
        dependencyContainer = DependencyContainer(creationMethod: PersistentContainerHelper.shared.createPersistentContainerWithInMemoryStores)
    }
    
    // MARK: Test Life Cycle
    override func setUp() {
        persistentContainer = CoreDataFlashCardServiceTests.dependencyContainer.persistentContainer
        flashCardService = CoreDataFlashCardServiceTests.dependencyContainer.flashCardService
    }

    override func tearDown() {
        flashCardService = nil
        persistentContainer = nil
    }

    // MARK: Tests
    func testNewContentPack() {
        guard let pack = flashCardService.newContentPack(title: "testPackTitle", description: "testPackDescription", author: "testAuthor") else {
            XCTFail("newContentPack did not return a ContentPack instance as expected")
            return
        }

        // Test method parameters
        XCTAssertEqual(pack.title, "testPackTitle", "Unexpected title")
        XCTAssertEqual(pack.packDescription, "testPackDescription", "Unexpected packDescription")
        XCTAssertEqual(pack.author, "testAuthor", "Unexpected author")

        // Test if object was successfully stored
        let fetchRequest: NSFetchRequest<ContentPack> = ContentPack.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            guard let fetchedPacks = try? context.fetch(fetchRequest) else {
                XCTFail("Failed to fetch ContentPacks after one was created")
                return
            }
            XCTAssertEqual(fetchedPacks.count, 1, "Unexpected number of ContentPacks fetched: \(fetchedPacks.count), expected 1")

            let fetchedPack: ContentPack = fetchedPacks[0]
            XCTAssertEqual(fetchedPack.title, "testPackTitle")
            XCTAssertEqual(fetchedPack.packDescription, "testPackDescription")
            XCTAssertEqual(fetchedPack.author, "testAuthor")

            XCTAssertEqual(fetchedPack.objectID, pack.objectID, "Unexpected objectID")
        }
    }

    func testNewCard() {
        XCTFail("test not implemented")
    }
}
