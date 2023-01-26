//
//  HabitDetailsView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 07.11.2022.
//

import SwiftUI

struct HabitDetailsView: View {
    
    @ObservedObject var habit: Habit
    @State private var habitText: String
    @State private var habitFrequency: String
    @State private var habitPriority: String
    @State private var editMode = false
    @State private var showAlert = false
        
    init(habit: Habit) {
        self.habit = habit
        habitText = habit.textDescription
        habitFrequency = habit.frequencyMode.string
        habitPriority = habit.priorityMode.string
    }
    
    var editButtonTitle: String {
        editMode ? "Готово" : "Править"
    }
    
    var descriptionView: some View {
        TextField("Описание привычки", text: $habitText, axis: .vertical)
            .font(.title2)
            .bold()
            .disabled(!editMode)
    }
    
    var settingsView: some View {
        Group {
            HStack {
                Image(systemName: "clock.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.cyan)
                Text("Как часто")
                Spacer()
                if editMode {
                    Picker("Частота", selection: $habitFrequency) {
                        ForEach(HabitFrequencyMode.allCases, id: \.string) { mode in
                            Text(mode.string)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Text(habitFrequency)
                        .foregroundColor(.secondary)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            HStack {
                Image(systemName: "flag.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.red)
                Text("Важность")
                Spacer()
                    .foregroundColor(.red)
                
                if editMode {
                    Picker("Важность", selection: $habitPriority) {
                        ForEach(HabitPriorityMode.allCases, id: \.string) { mode in
                            Text(mode.string.lowercased())
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Text(habitPriority)
                        .foregroundColor(.secondary)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
    }
    
    var progressView: some View {
        Group {
            HStack {
                Image(systemName: "bolt.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.yellow)
                Text("Прогресс")
                Spacer()
                Text(habit.progressFormattedString)
                    .foregroundColor(.secondary)
            }
            HStack {
                Image(systemName: "star.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.blue)
                Text("Рекорд")
                Spacer()
                Text("\(habit.bestResult)")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                descriptionView
            }
            
            Section {
                settingsView
            } header: {
                Text("Параметры")
            }
            
            Section {
                progressView
            } header: {
                Text("Прогресс")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(editButtonTitle) {
                toolbarButtonClicked()
            }
        }
        .alert("Изменив частоту привычки вы потеряете весь текущий прогресс!", isPresented: $showAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Хорошо", role: .destructive, action: applyChanges)
        }
    }
    
    func toolbarButtonClicked() {
        guard editMode else {
            withAnimation {
                editMode = true
            }
            return
        }
        
        if habitFrequency != habit.frequencyMode.string {
            showAlert = true
            return
        }
        applyChanges()
    }
    
    func applyChanges() {
        habit.text = habitText
        habit.priority = habitPriority
        
        if habitFrequency != habit.frequencyMode.string {
            habit.resetProgress()
        }
        
        CoreDataService.instance.saveContext()
        withAnimation {
            editMode = false
        }
    }
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitDetailsView(habit: DataController.testHabit)
        }
    }
}
