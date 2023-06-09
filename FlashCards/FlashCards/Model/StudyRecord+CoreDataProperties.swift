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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyRecord> {
        return NSFetchRequest<StudyRecord>(entityName: "StudyRecord")
    }
    
    
    @NSManaged public var timestamp: Date
    @NSManaged public var studyResult: Int64
    @NSManaged public var afterInterval: Int64
    @NSManaged public var card: Card

}

extension StudyRecord : Identifiable {

}

