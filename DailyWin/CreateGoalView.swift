//
//  CreateGoalView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct CreateGoalView: View {
    
    @State private var goalText: String = ""
    @State private var selectedPriority = GoalPriorityMode.high.string
    @State private var selectedFrequency = GoalFrequencyMode.everyday.string
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var needEndDate: Bool = false
    
    @State private var selectedDateMode = 0
    let datesMode = ["Дата начала", "Дата конца"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Опишите вашу цель", text: $goalText)
                }
                
                Section {
                    NavigationLink {
                        DatesSelectionView()
                    } label: {
                        Button("Окт 16. 2022 ... Окт 16. 2023") { }
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
                    
                } footer: {
                    Text("Параметры испытания можно будет изменить, но это сбросит его текущий прогресс")
                }
            }
            .navigationTitle("Новое испытание")
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
