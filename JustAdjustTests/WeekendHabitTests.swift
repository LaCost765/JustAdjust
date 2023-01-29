//
//  WeekendHabitTests.swift
//  JustAdjustTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import JustAdjust

final class WeekendHabitTests: CoreDataServiceTests {

    /// 5️⃣: ❓ ✍️ ❓ ✍️ ✅ ✅ ✍️
    func testWeekends_1() throws {
        
        setDayBy(number: 5)
        try setupHabit(
            text: "testWeekends_1",
            priority: .high,
            frequency: .weekends
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// 5️⃣: ❓ ✍️ ❓ ✍️ ❓ ✅ ✍️
    func testWeekends_2() throws {
        
        setDayBy(number: 5)
        try setupHabit(
            text: "testWeekends_2",
            priority: .high,
            frequency: .weekends
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 5️⃣: ❓ ✍️ ❓ ✍️ ❌ ✍️ ✅ ✍️
    func testWeekends_3() throws {
        
        setDayBy(number: 5)
        try setupHabit(
            text: "testWeekends_3",
            priority: .high,
            frequency: .weekends
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitUncompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 1️⃣: ✅ ✍️ ✍️ ✍️ 7️⃣ ✍️ ✅ ✅ ✍️
    func testWeekends_4() throws {
        
        setDayBy(number: 1)
        try setupHabit(
            text: "testWeekends_4",
            priority: .high,
            frequency: .weekends
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 7, expectedBestResult: "7 дней подряд", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 7, expectedBestResult: "7 дней подряд", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 8, expectedBestResult: "8 дней подряд", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 8, expectedBestResult: "8 дней подряд", expectedNeedToday: false)
    }
    
    /// 1️⃣: ❓ ✍️ ✍️ ✍️ 7️⃣ ✍️ ✅ ✅ ✍️
    func testWeekends_5() throws {
        
        setDayBy(number: 1)
        try setupHabit(
            text: "testWeekends_5",
            priority: .high,
            frequency: .weekends
        )
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
}
