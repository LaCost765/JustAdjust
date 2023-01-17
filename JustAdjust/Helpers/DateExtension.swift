//
//  DateExtension.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import Foundation

extension Date {
    
    /// Номер дня недели: число от 1(вс) до 7(сб)
    var weekdayNumber: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var date: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var nextDay: Date {
        guard let day = Calendar.current.date(byAdding: .day, value: 1, to: self) else {
            assertionFailure()
            return .now
        }
        return day
    }
    
    var nextWeekendDay: Date {
        
        if self.weekdayNumber == 7 {
            return self.nextDay
        }
        
        guard let nextWeekend = Calendar.current.nextWeekend(startingAfter: self) else {
            assertionFailure()
            return .now
        }
        return nextWeekend.start
    }
    
    var nextWeekday: Date {
        var daysToAdd: Int {
            switch self.weekdayNumber {
            case 2...5:
                return 1
            case 6:
                return 3
            case 7:
                return 2
            case 1:
                return 1
            default:
                assertionFailure()
                return 0
            }
        }
        
        guard let nextWeekDay = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) else {
            assertionFailure()
            return .now
        }
        
        return nextWeekDay
    }
    
    var isWeekend: Bool {
        let number = self.weekdayNumber
        return (number == 7) || (number == 1)
    }
    
    var isWeekday: Bool {
        let number = self.weekdayNumber
        return (number > 1) && (number < 7)
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
    
    func isEqual(to date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    
    func isLessOrEqual(to date: Date) -> Bool {
        self.isLess(than: date) || self.isEqual(to: date)
    }
    
    /// Получить следующую дату соответствующую номеру дня недели
    /// - Parameter number: Номер дня: от 1(вс) до 7(сб)
    /// - Returns: Дата
    func getNextDayBy(number: Int) -> Date {
        let delta: Int = {
            if number > self.weekdayNumber {
                return number - self.weekdayNumber
            } else {
                return (7 - self.weekdayNumber) + number
            }
        }()
        
        return Calendar.current.date(byAdding: .day, value: delta, to: self)!
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
    
    func getDifferenceInDays(with date: Date) -> Int {
        Calendar.current.numberOfDaysBetween(date, and: self)
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1
    }
}
