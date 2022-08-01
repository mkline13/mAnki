//
//  Deck+CoreDataProperties.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var title: String
    @NSManaged public var deckDescription: String
    @NSManaged public var newCardsPerDay: Int64
    @NSManaged public var reviewCardsLimit: Int64
    @NSManaged public var cards: NSSet
    @NSManaged public var associatedContentPacks: NSSet

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for associatedContentPacks
extension Deck {

    @objc(addAssociatedContentPacksObject:)
    @NSManaged public func addToAssociatedContentPacks(_ value: ContentPack)

    @objc(removeAssociatedContentPacksObject:)
    @NSManaged public func removeFromAssociatedContentPacks(_ value: ContentPack)

    @objc(addAssociatedContentPacks:)
    @NSManaged public func addToAssociatedContentPacks(_ values: NSSet)

    @objc(removeAssociatedContentPacks:)
    @NSManaged public func removeFromAssociatedContentPacks(_ values: NSSet)

}

extension Deck : Identifiable {

}
