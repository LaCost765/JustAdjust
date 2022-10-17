//
//  DateExtension.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import Foundation

extension Date {
    
    /// Преобразовать дату в строку
    /// - Parameters:
    ///   - dateStyle: Формат даты
    ///   - timeStyle: Формат времени
    /// - Returns: Дата в формате строки
    func getFormatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
