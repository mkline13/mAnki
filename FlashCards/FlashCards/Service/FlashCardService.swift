//
//  FlashCardService.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData


protocol FlashCardService {
    // MARK: Initializers
    init(container: NSPersistentContainer)
    
    // MARK: Service
    func newContentPack(withTitle title: String, packDescription description: String, author: String) -> ContentPack?
    func newCard(in: ContentPack, frontContent front: String, backContent back: String, deck: Deck?) -> Card?
}
