# mAnki

SRS flashcard app for iOS inspired by Anki

https://apps.ankiweb.net

Created as a final project for CS399 iOS Development at the University of Oregon.


## Instructions

1. Create a new Content Pack. Content Packs are essentially categories that you can add new cards to. If you were studying Spanish, you could add packs for Verbs, Nouns, Sentences, etc.
    - tap on the "Content Packs" tab
    - tap the plus button in the upper right corner to add a new Content Pack
    - fill out the form and press save
2. Add cards to the Content Pack
    - tap on the newly created Content Pack
    - tap the icon in the lower right corner to add a new card
    - fill out the form and tap save
3. Create a new Deck for study. Decks contain cards that you are currently studying. To return to the Spanish example, you would want to entitle the Deck "Spanish Study" or something similar.
    - return to the Content Pack browser and tap the "Decks" tab button
    - tap the plus button to add a new Deck
    - fill out the form
    - tap the blue plus button to associate the Content Pack you created earlier to this deck. This will allow you to automatically draw new cards from the associated Content Packs.
    - tap save
4. Study!
    - tap on your newly created deck
    - tap the "Auto-Add Cards" button
    - tap the "Begin Studying" button
    - when viewing flashcards, you can tap the screen to flip the card
    - when viewing the back side of the card, tap the X button if you were not able to remember the content on the back or tap the checkmark button to mark the card as learned
    - cards marked as learned will appear after the review interval determined by the SRS algorithm
    - failed cards will be repeatedly shown until they are marked as learned

    
## Development notes

- developed in Swift using the UIKit framework
- wrote the app entirely in code without using Interface Builder
- used CoreData to store user-generated content
- wrote unit tests using the XCTest framework
- wrote automated UI tests with XCUITest
- used dependency injection to simplify testing


