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
    convenience init(studyDate: Date, studyStatus: StudyStatus, interval: Int64, nextStudyDate: Date, card: Card, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.studyDate = studyDate
        self.studyStatus = studyStatus
        self.card = card
        
        self.interval = interval
        self.nextStudyDate = nextStudyDate
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
