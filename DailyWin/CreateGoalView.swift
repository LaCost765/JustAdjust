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
    @State private var selectedDate: Date = Date()
    @State private var needEndDate: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextEditor(text: $goalText)
                } footer: {
                    Text("Опишите вашу цель")
                }
                
                Section {
                    Picker("Приоритет", selection: $selectedPriority) {
                        ForEach(GoalPriorityMode.allCases, id: \.iconName) { mode in
                            Image(mode.iconName)
                        }
                    }
                    .pickerStyle(.segmented)
                } footer: {
                    Text("Укажите важность вашей цели. Данная настройка нужна лишь для вашего удобства при поиске или фильтрации ваших целей")
                }
                
                Section {
                    Picker("Частота", selection: $selectedFrequency) {
                        ForEach(GoalFrequencyMode.allCases, id: \.string) { mode in
                            Text(mode.string)
                        }
                    }
                    .pickerStyle(.segmented)
                } footer: {
                    Text("Выбранная частота будет влиять на то, появится ли цель в списке задач на сегодня или нет")
                }
                
                Section {
                    ZStack {
                        DatePicker("Дата", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .blur(radius: needEndDate ? 0 : 10)
                            .allowsHitTesting(needEndDate)
                        
                        if !needEndDate {
                            Text("Нажмите чтобы выбрать")
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation {
                                        needEndDate = true
                                    }
                                }
                        }
                        
                    }
                } footer: {
                    Text("Выберите дату, если хотите, чтобы после цель больше не появлялась")
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
