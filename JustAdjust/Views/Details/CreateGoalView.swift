//
//  CreateGoalView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct CreateGoalView: View {
    
    @Environment(\.dismiss) var dismiss
    let service: CoreDataServiceProtocol = CoreDataService.instance
    
    @State private var goalText: String = ""
    @State private var selectedPriority = GoalPriorityMode.high.string
    @State private var selectedFrequency = GoalFrequencyMode.everyday.string
    @State private var startDate: Date = Date()
    @State private var showCalendar = false
    @State private var showErrorAlert = false
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Описание", text: $goalText)
                        .submitLabel(.done)
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
                        DatePicker(
                            "Выбрать дату",
                            selection: $startDate,
                            in: Date()...,
                            displayedComponents: .date
                        )
                            .environment(\.locale, Locale.init(identifier: "ru"))
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
                        .disabled(goalText.isEmpty)
                }
            }
            .defaultAlert(
                isPresented: $showErrorAlert,
                title: "Упс 🫣",
                message: "Произошла какая-то ошибка, попробуйте еще раз"
            )
            .navigationTitle("Новая привычка")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func createGoal() {
        
        do {
            _ = try service.addNewGoal(
                text: goalText,
                priority: selectedPriority,
                frequency: selectedFrequency,
                startDate: startDate
            )
        } catch {
            showErrorAlert = true
        }
        dismiss()
    }
}

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
    }
}
