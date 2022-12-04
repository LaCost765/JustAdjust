//
//  Goal+Enums.swift
//  DailyWin
//
//  Created by Egor Baranov on 03.12.2022.
//

import Foundation
import SwiftUI

extension Goal {
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
        case high = "высокая"
        case middle = "средняя"
        case low = "низкая"
        
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
