//
//  Card+CoreDataClass.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {
    convenience init(creationDate: Date, frontContent front: String, backContent back: String, contentPack pack: ContentPack, deck: Deck?, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.creationDate = creationDate
        self.frontContent = front
        self.backContent = back
        self.contentPack = pack
        self.deck = deck
    }
}
