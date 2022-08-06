//
//  StudyRecord+CoreDataProperties.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData


extension StudyRecord {
    static let entityName: String = "StudyRecord"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyRecord> {
        return NSFetchRequest<StudyRecord>(entityName: entityName)
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var studyStatus: String
    @NSManaged public var previousInterval: Int64
    @NSManaged public var nextInterval: Int64
    @NSManaged public var card: Card

}

extension StudyRecord : Identifiable {

}
