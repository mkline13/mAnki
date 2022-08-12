//
//  Variable+CoreDataClass.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//
//

import Foundation
import CoreData

@objc(Variable)
public class Variable: NSManagedObject {
    convenience init(key: String, value: Value, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.variableKey = key
        self.variableValue = value.toString()
    }
    
    enum Value {
        case integer(Int)
        case double(Double)
        case string(String)
        
        func toString() -> String {
            switch self {
            case .integer(let int):
                return "int: \(int)"
            case .double(let double):
                return "dub: \(double)"
            case .string(let string):
                return "str: \(string)"
            }
        }
        
        static func fromString(value: String) -> Value {
            let type = value.prefix(3)
            let value = value.dropFirst(5)
            
            switch type {
            case "int":
                return Value.integer(Int(value) ?? 0)
            case "dub":
                return Value.double(Double(value) ?? 0)
            case "str":
                return Value.string(String(value))
            default:
                fatalError("ValueType not supported")
            }
        }
    }
}
