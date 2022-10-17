//
//  CreateGoalView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct CreateGoalView: View {
    
    @State private var goalText: String = ""
    @State private var selectedPriority = GoalPriorityMode.high.iconName
    @State private var selectedFrequency = GoalFrequencyMode.everyday.string
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var needEndDate: Bool = false
    
    @State private var selectedDateMode = 0
    let datesMode = ["Дата начала", "Дата конца"]
    
    var body: some View {
        NavigationView {
            Form {
//                Section {
//                    TextEditor(text: $goalText)
//                } footer: {
//                    Text("Опишите вашу цель")
//                }
//
//                Section {
//                    Picker("Приоритет", selection: $selectedPriority) {
//                        ForEach(GoalPriorityMode.allCases, id: \.iconName) { mode in
//                            Image(mode.iconName)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                } footer: {
//                    Text("Укажите важность вашей цели. Данная настройка нужна лишь для вашего удобства при поиске или фильтрации ваших целей")
//                }
                
//                Section {
//                    Picker("Частота", selection: $selectedFrequency) {
//                        ForEach(GoalFrequencyMode.allCases, id: \.string) { mode in
//                            Text(mode.string)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                } footer: {
//                    Text("Выбранная частота будет влиять на то, появится ли цель в списке задач на сегодня или нет")
//                }
//
                Section {
                    VStack {
                        Picker("", selection: $selectedDateMode) {
                            Text("Дата начала").tag(0)
                            Text("Дата конца").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        let isDatePickerEnabled = (selectedDateMode == 0) || needEndDate
                        
                        DatePicker("", selection: selectedDateMode == 0 ? $startDate : $endDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .blur(radius: isDatePickerEnabled ? 0 : 10)
                            .allowsHitTesting(isDatePickerEnabled)
                        
                        if selectedDateMode == 1 {
                            Text(needEndDate ? "Удалить" : "Нажмите чтобы выбрать")
                                .font(.headline)
                                .foregroundColor(needEndDate ? .red : .blue)
                                .onTapGesture {
                                    withAnimation {
                                        needEndDate.toggle()
                                    }
                                }
                                .padding(.bottom)
                                .transition(.opacity)
                        }
                    }
                } footer: {
                    Text("Выберите даты")
                }
            }
            .navigationTitle("Новая цель")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Сохранить") { }
            }
        }
    }
}

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
    }
}
