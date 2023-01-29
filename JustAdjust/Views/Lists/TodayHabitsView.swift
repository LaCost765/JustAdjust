//
//  TodayHabitsView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI
import CoreData

struct TodayHabitsView: View {
    
    let service: CoreDataServiceProtocol = CoreDataService.instance
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.progressInfo?.originStartDate, order: .reverse)
        ],
        predicate: DataController.todayHabitsPredicate,
        animation: .easeIn
    )
    var habits: FetchedResults<Habit>
    
    var todayHabits: [Habit] {
        habits.filter { $0.needNow() }
    }
    
    @State private var selectedHabit: Habit?
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var stubViewOpacity: Double = 0
    
    private var overlay: some View {
        ZStack {
            ViewConstats.gradient.opacity(0.8)
            
            HStack {
                Spacer()
                Button(action: markHabitUncompleted) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
                Spacer()
                Button(action: markHabitCompleted) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation {
                showOverlay = false
                selectedHabit = nil
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
                    ForEach(todayHabits) { habit in
                        HabitCardView(model: habit)
                            .todayCardStyle(isSelected: habit == selectedHabit, isOverlayShown: showOverlay)
                            .onTapGesture {
                                withAnimation {
                                    if selectedHabit == habit {
                                        showOverlay = true
                                    } else {
                                        showOverlay = false
                                        selectedHabit = habit
                                    }
                                }
                            }
                            .overlay {
                                if showOverlay, habit == selectedHabit { overlay }
                            }
                            .padding(.bottom, 4)
                    }
                    .padding(.horizontal)
                }
                
                if todayHabits.isEmpty {
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
        .defaultAlert(
            isPresented: $showErrorAlert,
            title: "Упс 🫣",
            message: "Произошла какая-то ошибка, попробуйте еще раз"
        )
        .defaultAlert(
            isPresented: $showAlert,
            title: "Почему нет целей?",
            message: "Скорее всего вы закрыли все привычки на сегодня. Если нет, перейдите на другой экран и создайте новые"
        )
    }
    
    func markHabitCompleted() {
        guard let habit = selectedHabit else {
            assertionFailure()
            return
        }
        
        do {
            try service.markHabitCompleted(habit: habit)
        } catch {
            showErrorAlert = true
        }
        
        withAnimation {
            selectedHabit = nil
            showOverlay = false
        }
    }
    
    func markHabitUncompleted() {
        guard let habit = selectedHabit else {
            assertionFailure()
            return
        }
        
        do {
            try service.markHabitUncompleted(habit: habit)
        } catch {
            showErrorAlert = true
        }
        
        withAnimation {
            selectedHabit = nil
            showOverlay = false
        }
    }
}

struct TodayHabitsView_Previews: PreviewProvider {
    static var previews: some View {
        TodayHabitsView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
