//
//  ContentPack+CoreDataClass.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//
//

import Foundation
import CoreData

@objc(ContentPack)
public class ContentPack: NSManagedObject {
    convenience init(title: String, packDescription description: String, author: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.packDescription = description
        self.author = author
    }
}
