//
//  CreateHabitView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct CreateHabitView: View {
    
    @Environment(\.dismiss) var dismiss
    let service: CoreDataServiceProtocol = CoreDataService.instance
    
    @State private var habitText: String = ""
    @State private var selectedPriority = HabitPriorityMode.high.string
    @State private var selectedFrequency = HabitFrequencyMode.everyday.string
    @State private var startDate: Date = Date()
    @State private var showCalendar = false
    @State private var showErrorAlert = false
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Описание", text: $habitText, axis: .vertical)
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
                        ForEach(HabitPriorityMode.allCases, id: \.string) { mode in
                            Text(mode.string.lowercased())
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Частота", selection: $selectedFrequency) {
                        ForEach(HabitFrequencyMode.allCases, id: \.string) { mode in
                            Text(mode.string)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Параметры")
                }
                
                Section {
                    Button("Создать", action: createHabit)
                        .disabled(
                            habitText
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .isEmpty
                        )
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
    
    private func createHabit() {
        
        do {
            _ = try service.addNewHabit(
                text: habitText,
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

struct CreateHabitView_Previews: PreviewProvider {
    static var previews: some View {
        CreateHabitView()
    }
}
