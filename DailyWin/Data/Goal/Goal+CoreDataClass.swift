//
//  Goal+CoreDataClass.swift
//  DailyWin
//
//  Created by Egor Baranov on 30.10.2022.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Goal)
public class Goal: NSManagedObject {
    
}

extension Goal {
   
    func markCompleted() {
        lastActionDate = .now
        progressInfo?.markCompleted()
    }
    
    func markUncompleted() {
        lastActionDate = .now
        progressInfo?.markUncompleted()
    }
    
    var wrappedText: String {
        text ?? "Не удалось получить"
    }
    
    var isNeedToday: Bool {
        guard let startDate = progressInfo?.originStartDate
        else {
            fatalError()
        }

        let dateCondition = .now > startDate

        var frequencyCondition: Bool {
            let numberOfWeekday = Date.now.weekdayNumber
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

            return lastActionDate.isLess(than: .now)
        }

        return dateCondition && frequencyCondition && uncompleteCondition
    }
}

extension Goal {
    
    var currentProgressInDays: Int {
        guard let progressInfo = progressInfo,
              let currentActionDate = progressInfo.currentActionDate,
              let currentStartDate = progressInfo.currentStartDate
        else {
            fatalError()
        }
        
        if currentActionDate < .now || currentStartDate == currentActionDate {
            return 0
        }
        
        if let lastActionDate = lastActionDate {
            return lastActionDate.getDifferenceInDays(with: currentStartDate)
        } else {
            // такого по идее быть не должно
            return 0
        }
    }
    
    var formattedDaysInRow: String {
        
        let daysInRow = currentProgressInDays
        
        guard daysInRow < 10 || daysInRow > 20 else {
            return "дней подряд"
        }

        let lastDigit = daysInRow % 10
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
    
    var priorityMode: PriorityMode {
        guard let priority = priority,
              let mode = PriorityMode.init(rawValue: priority)
        else { return .low }
        return mode
    }
    
    var frequencyMode: FrequencyMode {
        guard let frequency = frequency,
              let frequencyMode = FrequencyMode.init(rawValue: frequency)
        else { return .everyday }
        return frequencyMode
    }
}

extension Goal {
    
    enum PriorityMode: String, CaseIterable {
        case high = "Высокая"
        case middle = "Средняя"
        case low = "Низкая"
        
        var string: String {
            self.rawValue
        }
        
        var iconColor: Color {
            switch self {
            case .high:
                return .red
            case .middle:
                return .orange
            case .low:
                return.green
            }
        }
    }
    
    enum FrequencyMode: String, CaseIterable {
        case everyday = "каждый день"
        case weekdays = "по будням"
        case weekends = "по выходным"
        
        var string: String {
            self.rawValue
        }
    }
}

typealias GoalFrequencyMode = Goal.FrequencyMode
typealias GoalPriorityMode = Goal.PriorityMode
