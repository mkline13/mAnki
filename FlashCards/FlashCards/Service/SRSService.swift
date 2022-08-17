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
    
    func calculateInterval(previousInterval: Int64, studyStatus: StudyResult) -> Int64 {
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
            
            if previousInterval < firstInterval {
                return firstInterval
            }
            else if previousInterval < secondInterval {
                return secondInterval
            }
            else {
                return Int64(Float(previousInterval) * multiplier)
            }
        }
    }
    
    
    func calculateDueDate(interval: Int64, studyDate: Date, studyStatus: StudyResult) -> Date {
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
    
    func computeNewStatus(for card: Card, studyResult: StudyResult) -> Card.Status {
        switch studyResult {
        case .failure:
            return .learning
        case .success:
            return .review
        }
    }
    
    // MARK: Properties
    private let firstInterval: Int64
    private let secondInterval: Int64
    private let multiplier: Float
}
