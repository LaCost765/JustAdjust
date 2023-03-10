//
//  Habit+CoreDataClass.swift
//  JustAdjust
//
//  Created by Egor Baranov on 30.10.2022.
//
//

import Foundation
import CoreData

typealias HabitFrequencyMode = Habit.FrequencyMode
typealias HabitPriorityMode = Habit.PriorityMode

@objc(Habit)
public class Habit: NSManagedObject {
    
    var originStartDateString: String {
        guard let date = progressInfo?.originStartDate else {
            return ""
        }
        return date.getFormatted(dateStyle: .medium, timeStyle: .none)
    }
    
    /// Текстовое описание цели
    var textDescription: String {
        text ?? "Не удалось получить"
    }
    
    var progressFormattedString: String {
        let progress = getCurrentProgressInDays()
        
        return "\(progress) \(progress.daysInRowDescription)"
    }
    
    /// Лучший рекорд
    var bestResult: String {
        guard let result = progressInfo?.bestResult else {
            return "отсутствует"
        }
        
        return "\(result) \(Int(result).daysInRowDescription)"
    }
    
    func resetProgress() {
        lastActionDate = nil
        progressInfo?.resetProgress()
    }
    
    /// Нужно ли отображать цель сейчас
    func needNow(currentDate: Date = .now.date) -> Bool {
        
        var uncompleteCondition: Bool {
            guard let lastActionDate = lastActionDate else {
                return true
            }

            return lastActionDate.isLess(than: currentDate)
        }

        return shouldAppearToday(currentDate: currentDate) && uncompleteCondition
    }
    
    func shouldAppearToday(currentDate: Date) -> Bool {
        
        guard let startDate = progressInfo?.originStartDate
        else {
            return false
        }

        let dateCondition = currentDate >= startDate.date

        var frequencyCondition: Bool {
            let numberOfWeekday = currentDate.weekdayNumber
            switch frequencyMode {
            case .everyday:
                return true
            case .weekends:
                return numberOfWeekday == 7 || numberOfWeekday == 1
            case .weekdays:
                return numberOfWeekday > 1 && numberOfWeekday < 7
            }
        }
        
        return dateCondition && frequencyCondition
    }
}

extension Habit {
    
    /// Получить текуший прогресс в днях
    /// - Parameter currentDate: Текущая дата
    /// - Returns: Количество дней
    func getCurrentProgressInDays(currentDate: Date = .now.date) -> Int {
        guard let progressInfo = progressInfo,
              let currentActionDate = progressInfo.currentActionDate,
              let currentStartDate = progressInfo.currentStartDate
        else {
            return .zero
        }
        
        guard currentDate.isLessOrEqual(to: currentActionDate) else { return 0 }
        guard currentStartDate.isLess(than: currentActionDate) else { return 0 }
        guard let lastActionDate = lastActionDate else { return 0 }
        
        return lastActionDate.getDifferenceInDays(with: currentStartDate)
    }
}
