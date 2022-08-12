//
//  SRSService.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//

import Foundation


class SRSService {
    init (firstInterval: Int64 = 1, secondInterval: Int64 = 6, multiplier: Float = 2.0) {
        self.firstInterval = firstInterval
        self.secondInterval = secondInterval
        self.multiplier = multiplier
    }
    
    func calculateInterval(previousInterval: Int64, studyStatus: StudyStatus) -> Int64 {
        switch studyStatus {
        case .failure:
            return 0
        case .success:
            // SRS ALGORITHM:
            // I(n) = I(n-1) * m
            // where I(0) = 0, I(1) = 1, and I(2) = 6
            
            guard previousInterval >= 0 else {
                fatalError("Interval cannot be less than 0")
            }
            
            switch previousInterval {
            case 0:
                return firstInterval
            case firstInterval:
                return secondInterval
            default:
                return Int64(Float(previousInterval) * multiplier)
            }
        default:
            fatalError("Invalid study status")
        }
    }
    
    
    func calculateDueDate(interval: Int64, studyDate: Date, studyStatus: StudyStatus) -> Date {
        let calendar = Calendar(identifier: .iso8601)
        let dateComponentsInterval = DateComponents(day: Int(interval))
        
        let studyDate = Date.now
        let dueDate: Date
        
        if studyStatus == .success {
            let midnightOfStudyDate = calendar.startOfDay(for: studyDate)
            dueDate = calendar.date(byAdding: dateComponentsInterval, to: midnightOfStudyDate)!
        }
        else {
            dueDate = studyDate
        }
        
        return dueDate
    }
    
    // MARK: Properties
    let firstInterval: Int64
    let secondInterval: Int64
    let multiplier: Float
}
