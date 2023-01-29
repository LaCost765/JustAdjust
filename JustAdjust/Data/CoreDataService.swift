//
//  CoreDataService.swift
//  JustAdjust
//
//  Created by Egor Baranov on 03.12.2022.
//

import Foundation
import CoreData
import WidgetKit

protocol CoreDataServiceProtocol: AnyObject {
    
    var customDate: Date? { get set }
    
    /// Создать и добавить в контейнер новую цель
    /// - Parameters:
    ///   - text: Описание цель
    ///   - priority: Важность
    ///   - frequency: Частота
    ///   - startDate: Дата начала отсчета прогресса
    /// - Returns: Созданная цель
    func addNewHabit(
        text: String,
        priority: String,
        frequency: String,
        startDate: Date
    ) throws -> Habit
    
    /// Удалить цель из контейнера
    func deleteHabit(habit: Habit) throws
    
    /// Пометить цель выполненной
    func markHabitCompleted(habit: Habit) throws
    
    /// Пометить цель невыполненной
    func markHabitUncompleted(habit: Habit) throws
    
    /// Обновить состояние объектов в контейнере
    func refresh()
    
    /// Сохранить изменения контекста
    func saveContext()
    
    func getHabitsCountForToday() -> Double
    
    func getUncompletedHabitsCountForToday() -> Double
}

class CoreDataService: CoreDataServiceProtocol {
    
    static let instance: CoreDataServiceProtocol = CoreDataService()
    
    var currentDate: Date {
        customDate ?? .now.date
    }
    
    var customDate: Date?
    
    private init() { }
    
    private var context = DataController.context
    
    func saveContext() {
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getHabitsCountForToday() -> Double {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        guard let result = try? context.fetch(request) else {
            return .zero
        }
        
        let count = result.filter { $0.shouldAppearToday(currentDate: .now) }.count
        return Double(count)
    }
    
    func getUncompletedHabitsCountForToday() -> Double {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        guard let result = try? context.fetch(request) else {
            return .zero
        }
        
        let count = result.filter { $0.needNow(currentDate: .now) }.count
        return Double(count)
    }
    
    func addNewHabit(
        text: String,
        priority: String,
        frequency: String,
        startDate: Date
    ) throws -> Habit {
        let newHabit = Habit(context: context)
        newHabit.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        newHabit.priority = priority
        newHabit.frequency = frequency
        
        let progressInfo = ProgressInfo(
            habit: newHabit,
            startDate: startDate,
            context: context
        )
        newHabit.progressInfo = progressInfo
        
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return newHabit
    }
    
    func deleteHabit(habit: Habit) throws {
        context.delete(habit)
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func markHabitCompleted(habit: Habit) throws {
        
        guard let progressInfo = habit.progressInfo,
              let currentActionDate = progressInfo.currentActionDate
        else {
            assertionFailure()
            return
        }
        
        habit.lastActionDate = currentDate
        
        let shoudResetCurrentStart = !currentActionDate.isEqual(to: currentDate)
        progressInfo.markCompleted(currentDate: currentDate, shouldResetCurrentStart: shoudResetCurrentStart)
        
        let currentProgress = habit.getCurrentProgressInDays(currentDate: currentDate)
        if currentProgress > progressInfo.bestResult {
            progressInfo.bestResult = Int16(currentProgress)
        }
        
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func markHabitUncompleted(habit: Habit) throws {
        habit.lastActionDate = currentDate
        habit.progressInfo?.markUncompleted(currentDate: currentDate)
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func refresh() {
        context.refreshAllObjects()
    }
}
