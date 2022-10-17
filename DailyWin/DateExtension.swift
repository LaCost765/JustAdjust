//
//  DateExtension.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import Foundation

extension Date {
    
    var shortFormatted: String {
        self.getFormatted(dateStyle: .short, timeStyle: .none)
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
}
