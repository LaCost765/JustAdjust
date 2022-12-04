//
//  CoreDataService.swift
//  DailyWin
//
//  Created by Egor Baranov on 03.12.2022.
//

import Foundation
import CoreData

class CoreDataService {
    
    var currentDate: Date {
        customDate ?? .now.date
    }
    
    var customDate: Date?
    
    init(currentDate: Date? = nil) {
        customDate = currentDate
    }
    
    private var context = DataController.context
    
    func addNewGoal(
        text: String,
        priority: String,
        frequency: String,
        startDate: Date
    ) throws -> Goal {
        let newGoal = Goal(context: context)
        newGoal.text = text
        newGoal.priority = priority
        newGoal.frequency = frequency
        
        let progressInfo = ProgressInfo(
            goal: newGoal,
            startDate: startDate.date,
            context: context
        )
        newGoal.progressInfo = progressInfo
        
        try context.save()
        return newGoal
    }
    
    func deleteGoal(goal: Goal) throws {
        context.delete(goal)
        try context.save()
    }
    
    func markGoalCompleted(goal: Goal) {
        
        guard let progressInfo = goal.progressInfo,
              let currentActionDate = progressInfo.currentActionDate
        else {
            fatalError()
        }
        
        goal.lastActionDate = currentDate
        
        let shoudResetCurrentStart = !currentActionDate.isEqual(to: currentDate)
        progressInfo.markCompleted(currentDate: currentDate, shouldResetCurrentStart: shoudResetCurrentStart)
        
        let currentProgress = goal.getCurrentProgressInDays(currentDate: currentDate)
        if currentProgress > progressInfo.bestResult {
            progressInfo.bestResult = Int16(currentProgress)
        }
    }
    
    func markGoalUncompleted(goal: Goal) {
        goal.lastActionDate = currentDate
        goal.progressInfo?.markUncompleted(currentDate: currentDate)
    }
}
