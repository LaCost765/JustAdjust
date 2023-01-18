//
//  DataController.swift
//  JustAdjust
//
//  Created by Egor Baranov on 31.10.2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    static var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static var todayHabitsPredicate: NSPredicate {
        .init(
            format: "lastActionDate == nil OR lastActionDate < %@",
            Date.now.date as NSDate
        )
    }
    
    static let container: NSPersistentContainer = {
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lacost.JustAdjust")!
        let storeURL = containerURL.appendingPathComponent("CoreData.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        let container = NSPersistentContainer(name: "CoreData")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            guard let error = error else { return }
            fatalError("Core Data error: '\(error.localizedDescription)'.")
        }
        
        return container
    }()
    
    private init() { }
}

extension DataController {
    static var testHabit: Habit {
        let habit = Habit(context: context)
        habit.text = "Тестовая цель, не очень длинная, не очень короткая"
        habit.frequency = "каждый день"
        habit.priority = "Высокая"
        
        let progressInfo = ProgressInfo(habit: habit, startDate: .now, context: context)
        habit.progressInfo = progressInfo
        
        return habit
    }
}
