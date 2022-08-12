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

    @NSManaged public var interval: Int64
    @NSManaged public var studyResult: String
    @NSManaged public var studyDate: Date
    @NSManaged public var nextStudyDate: Date
    @NSManaged public var card: Card

}

extension StudyRecord : Identifiable {

}

