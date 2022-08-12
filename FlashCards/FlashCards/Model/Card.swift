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
    convenience init(creationDate: Date, frontContent front: String, backContent back: String, interval: Int64, dueDate: Date?, contentPack pack: ContentPack, deck: Deck?, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.creationDate = creationDate
        self.frontContent = front
        self.backContent = back
        
        self.srsInterval = interval
        self.srsDueDate = dueDate
        
        self.contentPack = pack
        self.deck = deck
        self.status = Status.new.rawValue
    }
    
    enum Status: Int64 {
        case new = 0
        case review
    }
}
