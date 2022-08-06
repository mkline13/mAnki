//
//  ContentPack+CoreDataProperties.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData


extension ContentPack {
    static let entityName: String = "ContentPack"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentPack> {
        return NSFetchRequest<ContentPack>(entityName: entityName)
    }

    @NSManaged public var title: String
    @NSManaged public var packDescription: String
    @NSManaged public var author: String
    @NSManaged public var cards: NSSet
    @NSManaged public var associatedDecks: NSSet

}

// MARK: Generated accessors for cards
extension ContentPack {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for associatedDecks
extension ContentPack {

    @objc(addAssociatedDecksObject:)
    @NSManaged public func addToAssociatedDecks(_ value: Deck)

    @objc(removeAssociatedDecksObject:)
    @NSManaged public func removeFromAssociatedDecks(_ value: Deck)

    @objc(addAssociatedDecks:)
    @NSManaged public func addToAssociatedDecks(_ values: NSSet)

    @objc(removeAssociatedDecks:)
    @NSManaged public func removeFromAssociatedDecks(_ values: NSSet)

}

extension ContentPack : Identifiable {

}
