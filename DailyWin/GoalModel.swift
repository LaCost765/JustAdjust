//
//  GoalModel.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import Foundation
import SwiftUI

protocol GoalViewModel: Identifiable {
    
    var goalText: String { get }
    var daysInRow: Int { get }
    var formattedDaysInRow: String { get }
    var priorityIconName: String { get }
    var frequency: String { get }
    var formattedEndDate: String { get }
}

struct GoalModel {
    
    let id: UUID = UUID()
    let text: String
    let daysInRow: Int
    let frequencyMode: FrequencyMode
    let priorityMode: PriorityMode
    let endDate: Date?
}

extension GoalModel: GoalViewModel {
    
    var goalText: String {
        text
    }
    
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
    
    var priorityIconName: String {
        priorityMode.iconName
    }
    
    var frequency: String {
        frequencyMode.string
    }
    
    var formattedEndDate: String {
        guard let endDate = endDate else {
            return "бессрочно"
        }
        
        return "до \(endDate.getFormatted(dateStyle: .medium, timeStyle: .none))"
    }
}

extension GoalModel {
    
    enum PriorityMode: CaseIterable {
        case high
        case middle
        case low
        
        var string: String {
            switch self {
            case .high:
                return "Высокая"
            case .middle:
                return "Средняя"
            case .low:
                return "Низкая"
            }
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
    
    enum FrequencyMode: CaseIterable {
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

extension GoalModel.FrequencyMode {
    enum WeekDays {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
}

typealias GoalFrequencyMode = GoalModel.FrequencyMode
typealias GoalPriorityMode = GoalModel.PriorityMode


