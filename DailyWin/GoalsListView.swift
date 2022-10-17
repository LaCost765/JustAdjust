//
//  GoalsListView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalsListView: View {
    
    @State private var showCreateScreen = false
    @State private var goalViewModels: [GoalModel] = [
        GoalModel(
            text: "Сделать 50 отжиманий утром, еще 50 вечером",
            daysInRow: 65,
            frequencyMode: .weekdays,
            priorityMode: .high,
            endDate: nil
        ),
        GoalModel(
            text: "Прочитать 30 страниц Робинзона Круза",
            daysInRow: 3,
            frequencyMode: .weekends,
            priorityMode: .middle,
            endDate: Date()
        ),
        GoalModel(
            text: "Лечь спать в 23:00",
            daysInRow: 1,
            frequencyMode: .everyday,
            priorityMode: .low,
            endDate: Date()
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(goalViewModels) { viewModel in
                    GoalView(model: viewModel)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
                .padding(.bottom)
            }
            .navigationTitle("Цели")
            .sheet(isPresented: $showCreateScreen) {
                CreateGoalView()
            }
            .toolbar {
                Button {
                    showCreateScreen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct GoalsListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsListView()
    }
}
