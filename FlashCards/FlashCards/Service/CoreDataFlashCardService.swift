//
//  CoreDataFlashCardService.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import CoreData


class CoreDataFlashCardService: FlashCardService {
    let container: NSPersistentContainer
    
    required init(container: NSPersistentContainer) {
        self.container = container
    }
    
}
