//
//  Variable+CoreDataProperties.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//
//

import Foundation
import CoreData


extension Variable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variable> {
        return NSFetchRequest<Variable>(entityName: "Variable")
    }

    @NSManaged public var variableKey: String
    @NSManaged public var variableValue: String
}

extension Variable : Identifiable {

}
