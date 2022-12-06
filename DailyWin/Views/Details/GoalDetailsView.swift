//
//  GoalDetailsView.swift
//  DailyWin
//
//  Created by Egor Baranov on 07.11.2022.
//

import SwiftUI

struct GoalDetailsView: View {
    
    @ObservedObject var goal: Goal
    @State private var editModeEnabled = false
    
    var body: some View {
        List {
            
            Section {
                Text(goal.textDescription)
                    .font(.title2)
                    .bold()
            } header: {
                Text("Цель")
            }
            
            Section {
                HStack {
                    Image(systemName: "clock.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundColor(.cyan)
                    Text("Как часто")
                    Spacer()
                    Text(goal.frequencyMode.string)
                        .foregroundColor(.secondary)
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
                    Text(goal.priorityMode.string)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Параметры")
            }
            
            Section {
                HStack {
                    Image(systemName: "bolt.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundColor(.yellow)
                    Text("Прогресс")
                    Spacer()
                    Text("\(goal.getCurrentProgressInDays()) \(goal.getDaysDescription(for: goal.getCurrentProgressInDays()))")
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
                    Text("\(goal.bestResult)")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Прогресс")
            }
        }
        .navigationTitle(editModeEnabled ? "Редактировать" : "Детали")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                editModeEnabled.toggle()
            } label: {
                Label("Изменить", systemImage: "square.and.pencil")
            }
        }
    }
}

struct GoalDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalDetailsView(goal: DataController.testGoal)
        }
    }
}
