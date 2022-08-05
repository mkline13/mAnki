//
//  StudyStatus.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//


enum StudyStatus: Int, CaseIterable, CustomStringConvertible {
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
    
    static func fromString(_ string: String) -> StudyStatus {
        switch string {
        case "failure":
            return StudyStatus.failure
        case "success":
            return StudyStatus.success
        default:
            return StudyStatus.deprecated
        }
    }
}
