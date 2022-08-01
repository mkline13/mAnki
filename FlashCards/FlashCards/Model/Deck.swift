//
//  Deck+CoreDataClass.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData

@objc(Deck)
public class Deck: NSManagedObject {
    convenience init (title: String, description: String, newCardsPerDay: Int64, reviewCardsLimit: Int64, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.deckDescription = description
        self.newCardsPerDay = newCardsPerDay
        self.reviewCardsLimit = reviewCardsLimit
    }
}
