//
//  Card+CoreDataProperties.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var frontContent: String
    @NSManaged public var backContent: String
    @NSManaged public var contentPack: ContentPack
    @NSManaged public var deck: Deck?
    @NSManaged public var studyRecords: NSSet

}

// MARK: Generated accessors for studyRecords
extension Card {

    @objc(addStudyRecordsObject:)
    @NSManaged public func addToStudyRecords(_ value: StudyRecord)

    @objc(removeStudyRecordsObject:)
    @NSManaged public func removeFromStudyRecords(_ value: StudyRecord)

    @objc(addStudyRecords:)
    @NSManaged public func addToStudyRecords(_ values: NSSet)

    @objc(removeStudyRecords:)
    @NSManaged public func removeFromStudyRecords(_ values: NSSet)

}

extension Card : Identifiable {

}
