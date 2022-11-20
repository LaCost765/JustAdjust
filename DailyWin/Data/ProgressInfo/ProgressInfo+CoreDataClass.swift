//
//  ProgressInfo+CoreDataClass.swift
//  DailyWin
//
//  Created by Egor Baranov on 08.11.2022.
//
//

import Foundation
import CoreData

@objc(ProgressInfo)
public class ProgressInfo: NSManagedObject {

    convenience init(
        goal: Goal,
        startDate: Date,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.goal = goal
        self.originStartDate = startDate
        
        let firstActionDate = calculateFirstActionDate()
        self.currentActionDate = firstActionDate
        self.currentStartDate = firstActionDate
    }
}

extension ProgressInfo {
    
    func markCompleted() {
        lastActionDate = .now
        currentActionDate = calculateNextActionDate()
    }
    
    func markUncompleted() {
        lastActionDate = .now
        let nextActionDate = calculateNextActionDate()
        currentActionDate = nextActionDate
        currentStartDate = nextActionDate
    }
    
    private func calculateNextActionDate() -> Date {
        guard let goal = goal else {
            fatalError()
        }
        
        switch goal.frequencyMode {
        case .everyday:
            return .now.nextDay
        case .weekends:
            return .now.nextWeekendDay
        case .weekdays:
            return .now.nextWeekday
        }
    }
    
    private func calculateFirstActionDate() -> Date {
        guard let goal = goal,
              let startDate = originStartDate
        else {
            fatalError()
        }
        
        switch goal.frequencyMode {
        case .everyday:
            return startDate
        case .weekends:
            if startDate.isWeekend {
                return startDate
            } else {
                return startDate.nextWeekendDay
            }
        case .weekdays:
            if startDate.isWeekday {
                return startDate
            } else {
                return startDate.nextWeekday
            }
        }
    }
}
