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
        self.status = Status.new
    }
    
    var status: Status {
        get {
            let value = Status(rawValue: self.studyStatus)
            if let value = value {
                return value
            }
            else {
                return Status.new
            }
        }
        set (newValue) {
            studyStatus = newValue.rawValue
        }
    }
    
    enum Status: Int64 {
        case new = 0
        case learning
        case review
    }
}
