//
//  CoreDataServiceTests+Weekdays.swift
//  DailyWinTests
//
//  Created by Egor Baranov on 04.12.2022.
//

import XCTest
@testable import DailyWin

extension CoreDataServiceTests {

    /// 5️⃣: ✅ ✅ ✍️ ✍️ ✅
    func testWeekdays_1() throws {
        
        setDayBy(number: 5)
        try setupGoal(
            text: "testWeekdays_1",
            priority: .high,
            frequency: .weekdays
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
        service.markGoalCompleted(goal: currentGoal)
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
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: false)
        setNextDay()
        
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
}
