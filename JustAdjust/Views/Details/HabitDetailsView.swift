//
//  HabitDetailsView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 07.11.2022.
//

import SwiftUI

struct HabitDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var habit: Habit
    @FocusState var textFieldFocused: Bool
    
    @State private var editMode: Bool = false
    @State private var habitText: String
    @State private var habitFrequency: String
    @State private var habitPriority: String
    @State private var showAlert = false
        
    init(habit: Habit) {
        self.habit = habit
        _habitText = State(initialValue: habit.textDescription)
        _habitFrequency = State(initialValue: habit.frequencyMode.string)
        _habitPriority = State(initialValue: habit.priorityMode.string)
    }
    
    var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var hasChanges: Bool {
        habit.textDescription != habitText.trimmingCharacters(in: .whitespacesAndNewlines) || habit.frequencyMode.string != habitFrequency || habit.priorityMode.string != habitPriority
    }
    
    var descriptionView: some View {
        TextField("Описание привычки", text: $habitText, axis: .vertical)
            .font(.title2)
            .bold()
            .focused($textFieldFocused)
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
                Menu {
                    Picker("Частота", selection: $habitFrequency) {
                        ForEach(HabitFrequencyMode.allCases, id: \.string) { mode in
                            Text(mode.string)
                        }
                    }
                } label: {
                    Text(habitFrequency)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)
                }
                .disabled(!editMode)
                .foregroundColor(editMode ? .accentColor : .secondary)
            }
            HStack {
                Image(systemName: "flag.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.red)
                Text("Важность")
                Menu {
                    Picker("Важность", selection: $habitPriority) {
                        ForEach(HabitPriorityMode.allCases, id: \.string) { mode in
                            Text(mode.string.lowercased())
                        }
                    }
                } label: {
                    Text(habitPriority)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)
                }
                .disabled(!editMode)
                .foregroundColor(editMode ? .accentColor : .secondary)
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
        .scrollContentBackground(.hidden)
        .background(isDarkMode ? Color.formDarkColor : Color.formLightColor)
        .navigationBarBackButtonHidden(editMode)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    toolbarButtonClicked()
                } label: {
                    Image(
                        systemName: editMode ? "checkmark.circle.fill" : "square.and.pencil.circle.fill"
                    )
                    .resizable()
                    .frame(width: 32, height: 32)
                }
                .disabled(editMode && !hasChanges)
            }
            
            if editMode {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") { undoChanges() }
                }
            }
        }
        .alert("Изменив частоту привычки вы потеряете весь текущий прогресс!", isPresented: $showAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Хорошо", role: .destructive, action: applyChanges)
        }
    }
    
    func toolbarButtonClicked() {
        guard editMode else {
            withAnimation { editMode = true }
            textFieldFocused = true
            return
        }
        
        guard habitFrequency == habit.frequencyMode.string else {
            showAlert = true
            return
        }
        applyChanges()
    }
    
    func undoChanges() {
        withAnimation {
            habitText = habit.textDescription
            habitPriority = habit.priorityMode.string
            habitFrequency = habit.frequencyMode.string
            editMode = false
        }
    }
    
    func applyChanges() {
        defer {
            withAnimation { editMode = false }
        }
        guard hasChanges else { return }
        
        habit.text = habitText.trimmingCharacters(in: .whitespacesAndNewlines)
        habitText = habit.textDescription
        habit.priority = habitPriority
        if habitFrequency != habit.frequencyMode.string {
            habit.frequency = habitFrequency
            habit.resetProgress()
        }
        CoreDataService.instance.saveContext()
    }
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitDetailsView(habit: DataController.testHabit)
        }
    }
}
