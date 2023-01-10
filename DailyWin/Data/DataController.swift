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
    
    static var todayGoalsPredicate: NSPredicate {
        .init(
            format: "lastActionDate == nil OR lastActionDate < %@",
            Date.now.date as NSDate
        )
    }
    
    static let container: NSPersistentContainer = {
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lacost.DailyWin")!
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
    static var testGoal: Goal {
        let goal = Goal(context: context)
        goal.text = "Тестовая цель, не очень длинная, не очень короткая"
        goal.frequency = "каждый день"
        goal.priority = "Высокая"
        
        let progressInfo = ProgressInfo(goal: goal, startDate: .now, context: context)
        goal.progressInfo = progressInfo
        
        return goal
    }
}
