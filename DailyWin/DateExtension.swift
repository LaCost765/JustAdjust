//
//  DateExtension.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import Foundation

extension Date {
    
    var date: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var shortFormatted: String {
        self.getFormatted(dateStyle: .short, timeStyle: .none)
    }
    
    func isLess(than date: Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        
        switch order {
        case .orderedSame, .orderedDescending:
            return false
        case .orderedAscending:
            return true
        }
    }
    
    /// Преобразовать дату в строку
    /// - Parameters:
    ///   - dateStyle: Формат даты
    ///   - timeStyle: Формат времени
    /// - Returns: Дата в формате строки
    func getFormatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: "ru")
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
    
    func getNumberOfWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
}
