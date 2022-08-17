//
//  FlashCardsUITests.swift
//  FlashCardsUITests
//
//  Created by Work on 8/5/22.
//

import XCTest

class FlashCardsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAddContentPackAndCard() throws {
        // Add a new content pack
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        
        XCTAssertTrue(tabBar.buttons["Content Packs"].exists)
        tabBar.buttons["Content Packs"].tap()
        
        let contentPackListNavBar = app.navigationBars["Content Packs"]
        XCTAssertTrue(contentPackListNavBar.exists)
        XCTAssertTrue(contentPackListNavBar.buttons["Add Content Pack"].exists)
        app.navigationBars["Content Packs"].buttons["Add Content Pack"].tap()
        
        let testContentPackName = "Test Content Pack A"
        do {
            // Editing new content pack settings
            let newContentPackNavBar = app.navigationBars["New Content Pack"]
            XCTAssertTrue(newContentPackNavBar.exists)
            
            let newContentPackForm = app.scrollViews.otherElements
            let titleField = newContentPackForm.textFields["ContentPackTitleField"]
            XCTAssertTrue(titleField.exists)
            
            titleField.tap()
            titleField.typeText(testContentPackName)
            
            let aboutField = newContentPackForm.textViews["ContentPackAboutField"]
            XCTAssertTrue(aboutField.exists)
            
            aboutField.tap()
            aboutField.typeText("About this new content pack A")
            
            let authorField = newContentPackForm.textFields["ContentPackAuthorField"]
            XCTAssertTrue(authorField.exists)
            
            authorField.tap()
            authorField.typeText("It's me I'm the author")
            
            let saveButton = newContentPackNavBar.buttons["ContentPackSaveButton"]
            XCTAssertTrue(saveButton.exists)
            
            saveButton.tap()
        }
        
        let contentPacksTable = app.tables["ContentPacksTable"]
        XCTAssertTrue(contentPacksTable.exists)
        
        do {
            contentPacksTable.cells[testContentPackName].firstMatch.tap()
            
            // Test Settings Button
            let cardBrowserNavBar = app.navigationBars["Cards"]
            XCTAssertTrue(cardBrowserNavBar.exists)
            
            let settingsButton = cardBrowserNavBar.buttons["SettingsButton"]
            XCTAssertTrue(settingsButton.exists)
            settingsButton.tap()
            
            // Content Pack Settings
            let contentPackSettingsNavBar = app.navigationBars["Content Pack Settings"]
            XCTAssertTrue(contentPackSettingsNavBar.exists)
            
            let backButton = contentPackSettingsNavBar.buttons["Cards"]
            XCTAssertTrue(backButton.exists)
            backButton.tap()
            
            // Create a cards
            let cardsToolbar = app.toolbars["CardsToolbar"]
            XCTAssertTrue(cardsToolbar.exists)
            
            let addCardButton = cardsToolbar.buttons["NewCardButton"]
            XCTAssertTrue(addCardButton.exists)
            addCardButton.tap()
            
            let newCardNavBar = app.navigationBars["New Card"]
            XCTAssertTrue(newCardNavBar.exists)
            
            let newCardForm = app.scrollViews.otherElements
            let frontContentField = newCardForm.textViews["FrontContentField"]
            XCTAssertTrue(frontContentField.exists)
            
            frontContentField.tap()
            frontContentField.typeText("Front of the card to ya")
            
            let backContentField = newCardForm.textViews["BackContentField"]
            XCTAssertTrue(backContentField.exists)
            
            backContentField.tap()
            backContentField.typeText("This is the text on the back of the card")
            
            let saveButton = newCardNavBar.buttons["SaveCardButton"]
            XCTAssertTrue(saveButton.exists)
            saveButton.tap()
        }
    }
    
    func testAddDeck() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        
        XCTAssertTrue(tabBar.buttons["Decks"].exists)
        tabBar.buttons["Decks"].tap()
        
        let deckListNavBar = app.navigationBars["Decks"]
        XCTAssertTrue(deckListNavBar.exists)
        
        let addDeckButton = deckListNavBar.buttons["AddDeckButton"]
        XCTAssertTrue(addDeckButton.exists)
        addDeckButton.tap()
        
        // Deck settings screen
        let newDeckNavBar = app.navigationBars["New Deck"]
        XCTAssertTrue(newDeckNavBar.exists)
        
        let newDeckForm = app.scrollViews.otherElements
        let titleField = newDeckForm.textFields["DeckTitleField"]
        XCTAssertTrue(titleField.exists)
        
        titleField.tap()
        titleField.typeText("New Deck Title Oh Boy")
        
        let aboutField = newDeckForm.textViews["DeckAboutField"]
        XCTAssertTrue(aboutField.exists)
        
        aboutField.tap()
        aboutField.typeText("Something about a new deck or something")
        
        let newCardsPerDayStepper = newDeckForm.steppers["NewCardsPerDayStepper"]
        XCTAssertTrue(newCardsPerDayStepper.exists)
        
        do {
            let incButton = newCardsPerDayStepper.buttons["Increment"]
            XCTAssertTrue(incButton.exists)
            incButton.tap()
            incButton.tap()
            
            let decButton = newCardsPerDayStepper.buttons["Decrement"]
            XCTAssertTrue(decButton.exists)
            decButton.tap()
        }
        
        let reviewCardsPerDayStepper = newDeckForm.steppers["ReviewCardsPerDayStepper"]
        XCTAssertTrue(reviewCardsPerDayStepper.exists)
        
        do {
            let incButton = reviewCardsPerDayStepper.buttons["Increment"]
            XCTAssertTrue(incButton.exists)
            incButton.tap()
            incButton.tap()
            
            let decButton = reviewCardsPerDayStepper.buttons["Decrement"]
            XCTAssertTrue(decButton.exists)
            decButton.tap()
        }
        
        let addPackButton = newDeckForm.buttons["AddAssociatedContentPacksButton"]
        XCTAssertTrue(addPackButton.exists)
        addPackButton.tap()
        
        // Add associated content pack if possible
        do {
            let selectContentPackNavBar = app.navigationBars["Select Content Packs"]
            XCTAssertTrue(selectContentPackNavBar.exists)
        }
        
        // Save
        let saveButton = newDeckNavBar.buttons["SaveButton"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        
        
        ///
        ///
//
//        let app = XCUIApplication()
//        app.navigationBars["Decks"]/*@START_MENU_TOKEN@*/.buttons["AddDeckButton"]/*[[".buttons[\"Add Deck\"]",".buttons[\"AddDeckButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let scrollViewsQuery = app.scrollViews
//        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0)
//        let steppersQuery = element.children(matching: .other).element(boundBy: 7).steppers
//        let incrementButton = steppersQuery.buttons["Increment"]
//        incrementButton.tap()
//        incrementButton.tap()
//        incrementButton.tap()
//
//        let decrementButton = steppersQuery.buttons["Decrement"]
//        decrementButton.tap()
//        decrementButton.tap()
//        decrementButton.tap()
//        decrementButton.tap()
//
//        let steppersQuery2 = element.children(matching: .other).element(boundBy: 9).steppers
//        let decrementButton2 = steppersQuery2.buttons["Decrement"]
//        decrementButton2.tap()
//        decrementButton2.tap()
//        decrementButton2.tap()
//
//        let incrementButton2 = steppersQuery2.buttons["Increment"]
//        incrementButton2.tap()
//        incrementButton2.tap()
//        incrementButton2.tap()
//        incrementButton2.tap()
//        scrollViewsQuery.otherElements.buttons["add"].tap()
        
    }
}
