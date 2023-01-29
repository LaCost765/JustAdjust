//
//  EverydayHabitTests.swift
//  JustAdjustTests
//
//  Created by Egor Baranov on 06.12.2022.
//

import XCTest
@testable import JustAdjust

final class EverydayHabitTests: CoreDataServiceTests {
    
    /// ✅ ✅ ✅ ✍️
    func testEveryday_1() throws {

        try setupHabit(
            text: "testEveryday_1",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ✅ ❌ ✍️
    func testEveryday_2() throws {

        try setupHabit(
            text: "testEveryday_2",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ✅ ❓ ✍️
    func testEveryday_3() throws {

        try setupHabit(
            text: "testEveryday_3",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// ❌ ✅ ✅ ✍️
    func testEveryday_4() throws {

        try setupHabit(
            text: "testEveryday_4",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ❓ ✅ ✍️
    func testEveryday_5() throws {

        try setupHabit(
            text: "testEveryday_5",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 1, expectedBestResult: "1 день", expectedNeedToday: false)
    }
    
    /// ✅ ❓ ✍️ ✅ ✅ ✍️
    func testEveryday_6() throws {

        try setupHabit(
            text: "testEveryday_6",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ✅ ❌ ✅ ✅ ❓ ✍️
    func testEveryday_7() throws {

        try setupHabit(
            text: "testEveryday_7",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: true)
    }
    
    /// ❌ ❌ ✍️ ✅ ✅ ✅ ✍️
    func testEveryday_8() throws {

        try setupHabit(
            text: "testEveryday_8",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: false)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: false)
        
        setNextDay()
        assertHabitData(expectedProgress: 3, expectedBestResult: "3 дня подряд", expectedNeedToday: true)
    }
    
    /// ✅ ❌ ❓ ✍️ ✅ ✅ ✍️
    func testEveryday_9() throws {

        try setupHabit(
            text: "testEveryday_9",
            priority: .high,
            frequency: .everyday
        )
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        setNextDay()
        
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "1 день", expectedNeedToday: true)
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 2, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
    
    /// ❓ ❓ ❓ ✍️ ✅ ✅ ❌ ✍️
    func testEveryday_10() throws {

        try setupHabit(
            text: "testEveryday_10",
            priority: .high,
            frequency: .everyday
        )
        
        setNextDay()
        setNextDay()
        setNextDay()
        assertHabitData(expectedProgress: 0, expectedBestResult: "0 дней", expectedNeedToday: true)
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitCompleted(habit: currentHabit)
        setNextDay()
        
        try service.markHabitUncompleted(habit: currentHabit)
        assertHabitData(expectedProgress: 0, expectedBestResult: "2 дня подряд", expectedNeedToday: false)
    }
}
