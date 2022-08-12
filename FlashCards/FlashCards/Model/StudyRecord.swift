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
    convenience init(timestamp: Date, studyStatus: StudyStatus, afterInterval: Int64, card: Card, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.timestamp = timestamp
        self.studyStatus = studyStatus
        self.afterInterval = afterInterval
        self.card = card
    }
    
    var studyStatus: StudyStatus {
        get {
            return StudyStatus.fromString(self.studyResult)
        }
        set (newValue) {
            self.studyResult = newValue.description
        }
    }
}
