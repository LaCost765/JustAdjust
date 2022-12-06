//
//  EverydayGoalTests.swift
//  DailyWinTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import DailyWin

final class EverydayGoalTests: CoreDataServiceTests {
    
    /// ✅ ✅ ✅ ✍️
    func testEveryday_1() throws {

        try setupGoal(
            text: "testEveryday_1",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ✅ ❌ ✍️
    func testEveryday_2() throws {

        try setupGoal(
            text: "testEveryday_2",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ✅ ❓ ✍️
    func testEveryday_3() throws {

        try setupGoal(
            text: "testEveryday_3",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// ❌ ✅ ✅ ✍️
    func testEveryday_4() throws {

        try setupGoal(
            text: "testEveryday_4",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ❓ ✅ ✍️
    func testEveryday_5() throws {

        try setupGoal(
            text: "testEveryday_5",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// ✅ ❓ ✍️ ✅ ✅ ✍️
    func testEveryday_6() throws {

        try setupGoal(
            text: "testEveryday_6",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ❌ ✅ ✅ ❓ ✍️
    func testEveryday_7() throws {

        try setupGoal(
            text: "testEveryday_7",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// ❌ ❌ ✍️ ✅ ✅ ✅ ✍️
    func testEveryday_8() throws {

        try setupGoal(
            text: "testEveryday_8",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertGoalData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: true)
    }
    
    /// ✅ ❌ ❓ ✍️ ✅ ✅ ✍️
    func testEveryday_9() throws {

        try setupGoal(
            text: "testEveryday_9",
            priority: .high,
            frequency: .everyday
        )
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        setNextDay()
        
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ❓ ❓ ❓ ✍️ ✅ ✅ ❌ ✍️
    func testEveryday_10() throws {

        try setupGoal(
            text: "testEveryday_10",
            priority: .high,
            frequency: .everyday
        )
        
        setNextDay()
        setNextDay()
        setNextDay()
        assertGoalData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalCompleted(goal: currentGoal)
        setNextDay()
        
        service.markGoalUncompleted(goal: currentGoal)
        assertGoalData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
}
