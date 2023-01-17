//
//  WeekendGoalTests.swift
//  JustAdjustTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import JustAdjust

final class WeekendGoalTests: CoreDataServiceTests {

    /// 5️⃣: ❓ ✍️ ❓ ✍️ ✅ ✅ ✍️
    func testWeekends_1() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekends_1",
            priority: .high,
            frequency: .weekends
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// 5️⃣: ❓ ✍️ ❓ ✍️ ❓ ✅ ✍️
    func testWeekends_2() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekends_2",
            priority: .high,
            frequency: .weekends
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 5️⃣: ❓ ✍️ ❓ ✍️ ❌ ✍️ ✅ ✍️
    func testWeekends_3() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekends_3",
            priority: .high,
            frequency: .weekends
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalUncompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// 1️⃣: ✅ ✍️ ✍️ ✍️ 7️⃣ ✍️ ✅ ✅ ✍️
    func testWeekends_4() throws {
        
        setDayBy(number: 1)
        try setupGoal(
            text: "testWeekends_4",
            priority: .high,
            frequency: .weekends
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 7, expectedBestResult: "7 дней подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 7, expectedBestResult: "7 дней подряд", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 8, expectedBestResult: "8 дней подряд", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 8, expectedBestResult: "8 дней подряд", expectedNeedToday: false)
    }
    
    /// 1️⃣: ❓ ✍️ ✍️ ✍️ 7️⃣ ✍️ ✅ ✅ ✍️
    func testWeekends_5() throws {
        
        setDayBy(number: 1)
        try setupGoal(
            text: "testWeekends_5",
            priority: .high,
            frequency: .weekends
        )
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: true)
        try service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
}
