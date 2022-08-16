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
    convenience init (title: String, deckDescription description: String, newCardsPerDay: Int64, reviewCardsPerDay: Int64, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.deckDescription = description
        
        self.dailyNewCardLimit = newCardsPerDay
        self.dailyReviewCardLimit = reviewCardsPerDay
        
        self.previousStudySession = nil
        self.newCardsStudiedToday = 0
        self.reviewCardsStudiedToday = 0
    }
    
    var newCardsNeeded: Int {
        return Int(self.dailyNewCardLimit - self.newCardsStudiedToday)
    }
    
    var reviewCardsNeeded: Int {
        return Int(self.dailyReviewCardLimit - self.reviewCardsStudiedToday)
    }
}
