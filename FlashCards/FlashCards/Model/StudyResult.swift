//
//  StudyStatus.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//


enum StudyResult: Int, CaseIterable, CustomStringConvertible {
    case deprecated = -1
    case failure = 0
    case success = 1
    
    var description: String {
        switch self {
        case .deprecated:
            return "deprecated"
        case .failure:
            return "failure"
        case .success:
            return "success"
        }
    }
    
    static func fromString(_ string: String) -> StudyResult {
        switch string {
        case "failure":
            return StudyResult.failure
        case "success":
            return StudyResult.success
        default:
            return StudyResult.deprecated
        }
    }
}
