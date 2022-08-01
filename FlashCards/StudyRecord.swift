//
//  StudyRecord+CoreDataClass.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData

@objc(StudyRecord)
public class StudyRecord: NSManagedObject {
    convenience init(timestamp: Date, studyStatus status: Int64, previousInterval: Int64, nextInterval: Int64, card: Card, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.timestamp = timestamp
        self.studyStatus = status
        self.previousInterval = previousInterval
        self.nextInterval = nextInterval
    }
}
