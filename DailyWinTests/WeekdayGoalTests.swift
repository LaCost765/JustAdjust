//
//  WeekdayGoalTests.swift
//  DailyWinTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import DailyWin

final class WeekdayGoalTests: CoreDataServiceTests {
    
    /// 5️⃣: ✅ ✅ ✍️ ✍️ ✅
    func testWeekdays_1() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekdays_1",
            priority: .high,
            frequency: .weekdays
        )
        
        try service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        try service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 5, expectedBestResult: "5 дней подряд", expectedNeedToday: false)
    }
    
    /// 5️⃣: ✅ ❌ ✍️ ✍️ ✅
    func testWeekdays_2() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekdays_2",
            priority: .high,
            frequency: .weekdays
        )
        
        try service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        try service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ✅ ✅ ✍️
    func testWeekdays_3() throws {
        
        setDayBy(number: 7)
        try setupGoal(
            text: "testWeekdays_3",
            priority: .high,
            frequency: .weekdays
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        try service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ❌ ✅ ✍️
    func testWeekdays_4() throws {
        
        setDayBy(number: 7)
        try setupGoal(
            text: "testWeekdays_4",
            priority: .high,
            frequency: .weekdays
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        try service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
    }
    
    /// 7️⃣: ❓ ✍️ ❓ ✍️ ❓ ❌ ✍️
    func testWeekdays_5() throws {
        
        setDayBy(number: 7)
        try setupGoal(
            text: "testWeekdays_5",
            priority: .high,
            frequency: .weekdays
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        
        try service.markGoalUncompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
    }
}
