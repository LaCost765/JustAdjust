//
//  IntExtension.swift
//  JustAdjust
//
//  Created by Egor Baranov on 21.01.2023.
//

import Foundation

extension Int {
    /// Получить корректную форму слова "дни" в зависимости от числа
    var daysInRowDescription: String {
        
        switch self {
        case 0:
            return "дней"
        case 1:
            return "день"
        default:
            break
        }
        
        // проверяем последние 2 цифры, так как именно они влияют на склонение
        let value = self % 100
        
        guard value < 10 || value > 20 else {
            return "дней подряд"
        }
        
        let lastDigit = value % 10
        switch lastDigit {
        case 1:
            return "день подряд"
        case 2...4:
            return "дня подряд"
        default:
            return "дней подряд"
        }
    }
}
