//
//  WeekdayHabitTests.swift
//  JustAdjustTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import JustAdjust

final class WeekdayHabitTests: CoreDataServiceTests {
    
    /// 5️⃣: ✅ ✅ ✍️ ✍️ ✅
    func testWeekdays_1() throws {
        
        setDayBy(number: 5)
        try setupHabit(
            text: "testWeekdays_1",
            priority: .high,
            frequency: .weekdays
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 5, expectedBestResult: "5 дней подряд", expectedNeedToday: false)
    }
    
    /// 5️⃣: ✅ ❌ ✍️ ✍️ ✅
    func testWeekdays_2() throws {
        
        setDayBy(number: 5)
        try setupHabit(
            text: "testWeekdays_2",
            priority: .high,
            frequency: .weekdays
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ✅ ✅ ✍️
    func testWeekdays_3() throws {
        
        setDayBy(number: 7)
        try setupHabit(
            text: "testWeekdays_3",
            priority: .high,
            frequency: .weekdays
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ❌ ✅ ✍️
    func testWeekdays_4() throws {
        
        setDayBy(number: 7)
        try setupHabit(
            text: "testWeekdays_4",
            priority: .high,
            frequency: .weekdays
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ❓ ❌ ✍️
    func testWeekdays_5() throws {
        
        setDayBy(number: 7)
        try setupHabit(
            text: "testWeekdays_5",
            priority: .high,
            frequency: .weekdays
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
    }
}
