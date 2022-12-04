//
//  CoreDataServiceTests.swift
//  DailyWinTests
//
//  Created by Egor Baranov on 03.12.2022.
//

import XCTest
@testable import DailyWin

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

final class CoreDataServiceTests: XCTestCase {
    
    let service = CoreDataService(currentDate: .now.date)
    var currentGoal: Goal!
    
    var currentDate: Date {
        service.customDate ?? .now.date
    }
    
    override func tearDownWithError() throws {
        guard let goal = currentGoal else { return }
        try service.deleteGoal(goal: goal)
    }
    
    func setupGoal(
        text: String,
        priority: GoalPriorityMode,
        frequency: GoalFrequencyMode
    ) throws {
        let goal = try service.addNewGoal(
            text: text,
            priority: priority.string,
            frequency: frequency.string,
            startDate: currentDate
        )
        currentGoal = goal
    }
    
    func assertGoalData(
        expectedProgress: Int,
        expectedBestResult: String,
        expectedNeedToday: Bool
    ) {
        let progress = currentGoal.getCurrentProgressInDays(currentDate: currentDate)
        let bestResult = currentGoal.bestResult
        let isNeedToday = currentGoal.isNeedToday(currentDate: currentDate)
        
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
