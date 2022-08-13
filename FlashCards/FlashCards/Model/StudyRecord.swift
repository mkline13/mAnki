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
    convenience init(timestamp: Date, studyStatus: StudyResult, afterInterval: Int64, card: Card, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.timestamp = timestamp
        self.studyStatus = studyStatus
        self.afterInterval = afterInterval
        self.card = card
    }
    
    var studyStatus: StudyResult {
        get {
            return StudyResult.fromString(self.studyResult)
        }
        set (newValue) {
            self.studyResult = newValue.description
        }
    }
}
