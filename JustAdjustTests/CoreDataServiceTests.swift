//
//  CoreDataServiceTests.swift
//  JustAdjustTests
//
//  Created by Egor Baranov on 03.12.2022.
//

import XCTest
@testable import JustAdjust

/*
 ✅ - день когда цель была отмечена выполненной
 ❌ - день когда цель была отмечена невыполненной
 ❓- день когда пользователь ничего не делал с целью
 ✍️ - проверка данных
 1️⃣ - вс
 2️⃣ - пн
 ...
 7️⃣ - сб
*/

class CoreDataServiceTests: XCTestCase {
    
    let service = CoreDataService.instance
    var currentHabit: Habit!
    
    var currentDate: Date {
        service.customDate ?? .now.date
    }
    
    override func tearDownWithError() throws {
        guard let habit = currentHabit else { return }
        try service.deleteHabit(habit: habit)
    }
    
    func setupHabit(
        text: String,
        priority: HabitPriorityMode,
        frequency: HabitFrequencyMode
    ) throws {
        let habit = try service.addNewHabit(
            text: text,
            priority: priority.string,
            frequency: frequency.string,
            startDate: currentDate
        )
        currentHabit = habit
    }
    
    func assertHabitData(
        expectedProgress: Int,
        expectedBestResult: String,
        expectedNeedToday: Bool
    ) {
        let progress = currentHabit.getCurrentProgressInDays(currentDate: currentDate)
        let bestResult = currentHabit.bestResult
        let isNeedToday = currentHabit.needNow(currentDate: currentDate)
        
        XCTAssert(progress == expectedProgress, "Результат - \(progress), ожидалось - \(expectedProgress)")
        XCTAssert(bestResult == expectedBestResult, "Результат - \(bestResult), ожидалось - \(expectedBestResult)")
        XCTAssert(expectedNeedToday == isNeedToday, "Результат - \(isNeedToday), ожидалось - \(expectedNeedToday)")
    }
    
    func setNextDay() {
        service.customDate = currentDate.nextDay
    }
    
    func setDayBy(number: Int) {
        service.customDate = currentDate.getNextDayBy(number: number)
    }
}
