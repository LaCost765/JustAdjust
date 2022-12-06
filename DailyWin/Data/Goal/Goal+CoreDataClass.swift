//
//  Goal+CoreDataClass.swift
//  DailyWin
//
//  Created by Egor Baranov on 30.10.2022.
//
//

import Foundation
import CoreData

typealias GoalFrequencyMode = Goal.FrequencyMode
typealias GoalPriorityMode = Goal.PriorityMode

@objc(Goal)
public class Goal: NSManagedObject {
    
    /// Текстовое описание цели
    var textDescription: String {
        text ?? "Не удалось получить"
    }
    
    /// Лучший рекорд
    var bestResult: String {
        guard let result = progressInfo?.bestResult else {
            return "отсутствует"
        }
        
        return "\(result) \(getDaysDescription(for: Int(result)))"
    }
    
    /// Нужно ли отображать цель сегодня
    func isNeedToday(currentDate: Date = .now.date) -> Bool {
        guard let startDate = progressInfo?.originStartDate
        else {
            fatalError()
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

        var uncompleteCondition: Bool {
            guard let lastActionDate = lastActionDate else {
                return true
            }

            return lastActionDate.isLess(than: currentDate)
        }

        return dateCondition && frequencyCondition && uncompleteCondition
    }
}

extension Goal {
    
    /// Получить текуший прогресс в днях
    /// - Parameter currentDate: Текущая дата
    /// - Returns: Количество дней
    func getCurrentProgressInDays(currentDate: Date = .now.date) -> Int {
        guard let progressInfo = progressInfo,
              let currentActionDate = progressInfo.currentActionDate,
              let currentStartDate = progressInfo.currentStartDate
        else {
            fatalError()
        }
        
        guard currentDate.isLessOrEqual(to: currentActionDate) else { return 0 }
        guard currentStartDate.isLess(than: currentActionDate) else { return 0 }
        guard let lastActionDate = lastActionDate else { return 0 }
        
        return lastActionDate.getDifferenceInDays(with: currentStartDate)
    }
    
    /// Получить корректную форму во множественном числе слова "день"
    /// - Parameter days: Количество дней
    /// - Returns: Слово "день" в нужной форме
    func getDaysDescription(for days: Int) -> String {
        
        guard days < 10 || days > 20 else {
            return "дней подряд"
        }

        let lastDigit = days % 10
        switch lastDigit {
        case 0:
            return "дней"
        case 1:
            return "день"
        case 2...4:
            return "дня подряд"
        default:
            return "дней подряд"
        }
    }
}
