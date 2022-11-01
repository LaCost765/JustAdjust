//
//  DataController.swift
//  DailyWin
//
//  Created by Egor Baranov on 31.10.2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    static var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            guard let error = error else { return }
            fatalError("Core Data error: '\(error.localizedDescription)'.")
        }
        
        return container
    }()
    
    private init() { }
}
