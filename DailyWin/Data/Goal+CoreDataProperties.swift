//
//  Goal+CoreDataProperties.swift
//  DailyWin
//
//  Created by Egor Baranov on 30.10.2022.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var text: String?
    @NSManaged public var daysInRow: Int16
    @NSManaged public var frequency: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var priority: String?
}

extension Goal : Identifiable { }

extension Goal {
    var wrappedText: String {
        text ?? "Не удалось получить"
    }
}

extension Goal {

    var formattedDaysInRow: String {
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
        
        var iconName: String {
            switch self {
            case .high:
                return "redFlame"
            case .middle:
                return "orangeFlame"
            case .low:
                return "greenFlame"
            }
        }
    }
    
    enum FrequencyMode: String, CaseIterable {
        case everyday
        case weekdays
        case weekends
        
        var string: String {
            switch self {
            case .everyday:
                return "каждый день"
            case .weekdays:
                return "по будням"
            case .weekends:
                return "по выходным"
            }
        }
    }
}

typealias GoalFrequencyMode = Goal.FrequencyMode
typealias GoalPriorityMode = Goal.PriorityMode
