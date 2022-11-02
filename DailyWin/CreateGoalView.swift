//
//  CreateGoalView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct CreateGoalView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var goalText: String = ""
    @State private var selectedPriority = GoalPriorityMode.high.string
    @State private var selectedFrequency = GoalFrequencyMode.everyday.string
    @State private var startDate: Date = Date()
    
    @State private var showCalendar = false
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Опишите вашу цель", text: $goalText)
                }
                
                Section {
                    HStack {
                        Text("Начало")
                        Spacer()
                        Button(startDate.getFormatted(dateStyle: .medium, timeStyle: .none)) {
                            withAnimation {
                                showCalendar.toggle()
                            }
                        }

                    }
                    
                    if showCalendar {
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .environment(\.locale, Locale.init(identifier: "ru"))
                            .labelsHidden()
                            .id(startDate)
                            .datePickerStyle(.graphical)
                    }
                    
                    Picker("Важность", selection: $selectedPriority) {
                        ForEach(GoalPriorityMode.allCases, id: \.string) { mode in
                            Text(mode.string.lowercased())
                        }
                    }
                    
                    Picker("Частота", selection: $selectedFrequency) {
                        ForEach(GoalFrequencyMode.allCases, id: \.string) { mode in
                            Text(mode.string)
                        }
                    }
                } header: {
                    Text("Параметры")
                }
                
                Section {
                    Button("Создать", action: createGoal)
                }
            }
            .navigationTitle("Новое испытание")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func createGoal() {
        let newGoal = Goal(context: moc)
        newGoal.text = goalText
        newGoal.startDate = startDate
        newGoal.priority = selectedPriority
        newGoal.frequency = selectedFrequency
        try? moc.save()
        dismiss()
    }
}

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
    }
}
