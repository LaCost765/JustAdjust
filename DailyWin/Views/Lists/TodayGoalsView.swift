//
//  TodayGoalsView.swift
//  DailyWin
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI
import CoreData

struct TodayGoalsView: View {
    
    let service: CoreDataServiceProtocol = CoreDataService.instance
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: DataController.todayGoalsPredicate,
        animation: .easeIn
    )
    var goals: FetchedResults<Goal>
    
    var todayGoals: [Goal] {
        goals.filter { $0.isNeedToday() }
    }
    
    @State private var selectedGoal: Goal?
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var stubViewOpacity: Double = 0
    
    private var overlay: some View {
        ZStack {
            LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
            HStack {
                Spacer()
                Button(action: markGoalUncompleted) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
                Spacer()
                Button(action: markGoalCompleted) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var stubView: some View {
        VStack(spacing: 6) {
            Text("Нет актуальных целей")
                .font(.title)
                .foregroundColor(.secondary)
            Button {
                showAlert = true
            } label: {
                Text("Почему?")
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(todayGoals) { goal in
                        GoalView(model: goal)
                            .todayCardStyle(isSelected: goal == selectedGoal, isOverlayShown: showOverlay)
                            .onTapGesture {
                                withAnimation {
                                    if selectedGoal == goal {
                                        showOverlay = true
                                    } else {
                                        showOverlay = false
                                        selectedGoal = goal
                                    }
                                }
                            }
                            .overlay {
                                if showOverlay, goal == selectedGoal { overlay }
                            }
                    }
                    .padding(.horizontal)
                }
                
                if todayGoals.isEmpty {
                    stubView
                        .opacity(stubViewOpacity)
                        .onAppear {
                            withAnimation {
                                stubViewOpacity = 1
                            }
                        }
                }
            }
            .navigationTitle("На сегодня")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            service.refresh()
        }
        .defaultAlert(
            isPresented: $showErrorAlert,
            title: "Упс 🫣",
            message: "Произошла какая-то ошибка, попробуйте еще раз"
        )
        .defaultAlert(
            isPresented: $showAlert,
            title: "Почему нет целей?",
            message: "Скорее всего вы уже выполнили все цели на сегодня. Если нет, перейдите на другой экран и создайте новые"
        )
    }
    
    func markGoalCompleted() {
        guard let goal = selectedGoal else {
            assertionFailure()
            return
        }
        
        do {
            try service.markGoalCompleted(goal: goal)
        } catch {
            showErrorAlert = true
        }
        
        withAnimation {
            selectedGoal = nil
            showOverlay = false
        }
    }
    
    func markGoalUncompleted() {
        guard let goal = selectedGoal else {
            assertionFailure()
            return
        }
        
        do {
            try service.markGoalUncompleted(goal: goal)
        } catch {
            showErrorAlert = true
        }
        
        withAnimation {
            selectedGoal = nil
            showOverlay = false
        }
    }
}

struct TodayGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalsView()
    }
}
