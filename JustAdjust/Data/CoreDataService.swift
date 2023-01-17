//
//  CoreDataService.swift
//  JustAdjust
//
//  Created by Egor Baranov on 03.12.2022.
//

import Foundation
import CoreData
import WidgetKit

protocol CoreDataServiceProtocol {
    
    /// Создать и добавить в контейнер новую цель
    /// - Parameters:
    ///   - text: Описание цель
    ///   - priority: Важность
    ///   - frequency: Частота
    ///   - startDate: Дата начала отсчета прогресса
    /// - Returns: Созданная цель
    func addNewGoal(
        text: String,
        priority: String,
        frequency: String,
        startDate: Date
    ) throws -> Goal
    
    /// Удалить цель из контейнера
    func deleteGoal(goal: Goal) throws
    
    /// Пометить цель выполненной
    func markGoalCompleted(goal: Goal) throws
    
    /// Пометить цель невыполненной
    func markGoalUncompleted(goal: Goal) throws
    
    /// Обновить состояние объектов в контейнере
    func refresh()
    
    func getGoalsCountForToday() -> Double
    
    func getUncompletedGoalsCountForToday() -> Double
}

class CoreDataService: CoreDataServiceProtocol {
    
    static let instance = CoreDataService()
    
    var currentDate: Date {
        customDate ?? .now.date
    }
    
    var customDate: Date?
    
    private init() { }
    
    private var context = DataController.context
    
    func getGoalsCountForToday() -> Double {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        guard let result = try? context.fetch(request) else {
            return .zero
        }
        
        let count = result.filter { $0.shouldAppearToday(currentDate: .now) }.count
        return Double(count)
    }
    
    func getUncompletedGoalsCountForToday() -> Double {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        guard let result = try? context.fetch(request) else {
            return .zero
        }
        
        let count = result.filter { $0.needNow(currentDate: .now) }.count
        return Double(count)
    }
    
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
        WidgetCenter.shared.reloadAllTimelines()
        return newGoal
    }
    
    func deleteGoal(goal: Goal) throws {
        context.delete(goal)
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func markGoalCompleted(goal: Goal) throws {
        
        guard let progressInfo = goal.progressInfo,
              let currentActionDate = progressInfo.currentActionDate
        else {
            assertionFailure()
            return
        }
        
        goal.lastActionDate = currentDate
        
        let shoudResetCurrentStart = !currentActionDate.isEqual(to: currentDate)
        progressInfo.markCompleted(currentDate: currentDate, shouldResetCurrentStart: shoudResetCurrentStart)
        
        let currentProgress = goal.getCurrentProgressInDays(currentDate: currentDate)
        if currentProgress > progressInfo.bestResult {
            progressInfo.bestResult = Int16(currentProgress)
        }
        
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func markGoalUncompleted(goal: Goal) throws {
        goal.lastActionDate = currentDate
        goal.progressInfo?.markUncompleted(currentDate: currentDate)
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func refresh() {
        context.refreshAllObjects()
    }
}
