//
//  SettingsService.swift
//  FlashCards
//
//  Created by Work on 8/12/22.
//

import CoreData


class SettingsService {
    // MARK: Dependencies
    let persistentContainer: NSPersistentContainer
    
    // MARK: Initializers
    required init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    // MARK: Service
    func set(key: Key, value: Variable.Value) {
        if let variable = getVariable(key: key) {
            variable.variableValue = value.toString()
        }
        else {
            _ = Variable(key: key.rawValue, value: value, context: persistentContainer.viewContext)
        }
        
        saveViewContext()
    }
    
    func get(key: Key) -> Variable.Value? {
        guard let variable = getVariable(key: key) else {
            return nil
        }
        
        return Variable.Value.fromString(value: variable.variableValue)
    }
    
    func delete(key: Key) {
        guard let variable = getVariable(key: key) else {
            return
        }
        
        persistentContainer.viewContext.delete(variable)
        saveViewContext()
    }
    
    enum Key: String {
        case test = "test"
    }
    
    // MARK: - Helpers
    private func getVariable(key: Key) -> Variable? {
        let fetchRequest: NSFetchRequest<Variable> = Variable.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Variable.variableKey, ascending: true)
        ]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "variableKey == %@", key.rawValue)
        
        do {
            let variable = try persistentContainer.viewContext.fetch(fetchRequest).first
            return variable
        }
        catch {
            fatalError("Error when fetching Variable")
        }
    }
    
    private func saveViewContext() {
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            print("Failed to save viewContext, rolling back")
            persistentContainer.viewContext.rollback()
        }
    }
}
