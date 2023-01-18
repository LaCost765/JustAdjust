//
//  ProgressInfo+CoreDataClass.swift
//  JustAdjust
//
//  Created by Egor Baranov on 08.11.2022.
//
//

import Foundation
import CoreData

@objc(ProgressInfo)
public class ProgressInfo: NSManagedObject {

    convenience init(
        habit: Habit,
        startDate: Date,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.habit = habit
        self.originStartDate = startDate
        
        let firstActionDate = calculateFirstActionDate()
        self.currentActionDate = firstActionDate
        self.currentStartDate = firstActionDate
    }
}

extension ProgressInfo {
    
    func markCompleted(currentDate: Date = .now.date, shouldResetCurrentStart: Bool) {
        if shouldResetCurrentStart {
            currentStartDate = currentDate
        }
        currentActionDate = calculateNextActionDate(currentDate: currentDate)
    }
    
    func markUncompleted(currentDate: Date = .now.date) {
        let nextActionDate = calculateNextActionDate(currentDate: currentDate)
        currentActionDate = nextActionDate
        currentStartDate = nextActionDate
    }
    
    private func calculateNextActionDate(currentDate: Date) -> Date {
        guard let habit = habit else {
            assertionFailure()
            return .now
        }
        
        switch habit.frequencyMode {
        case .everyday:
            return currentDate.nextDay
        case .weekends:
            return currentDate.nextWeekendDay
        case .weekdays:
            return currentDate.nextWeekday
        }
    }
    
    private func calculateFirstActionDate() -> Date {
        guard let habit = habit,
              let startDate = originStartDate
        else {
            assertionFailure()
            return .now
        }
        
        switch habit.frequencyMode {
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
