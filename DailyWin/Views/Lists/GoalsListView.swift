//
//  GoalsListView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalsListView: View {
    
    let service: CoreDataServiceProtocol = CoreDataService.instance
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @State private var showCreateScreen = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            List {
                
                if goals.isEmpty {
                    Button("Добавить новую привычку") {
                        showCreateScreen = true
                    }
                }
                
                ForEach(goals) { goal in
                    NavigationLink {
                        GoalDetailsView(goal: goal)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(goal.textDescription)
                                .font(.headline)
                                .lineLimit(2)
                            Text(goal.frequencyMode.string)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteGoal(goal: goal)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            .defaultAlert(
                isPresented: $showErrorAlert,
                title: "Упс 🫣",
                message: "Произошла какая-то ошибка, попробуйте еще раз"
            )
            .navigationTitle("Привычки")
            .sheet(isPresented: $showCreateScreen) {
                CreateGoalView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // фикс из стековерфлоу
                    Text(showCreateScreen ? " " : "").hidden()
                    Button {
                        showCreateScreen = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
    }
    
    func deleteGoal(goal: Goal) {
        do {
            try service.deleteGoal(goal: goal)
        } catch {
            showErrorAlert = true
        }
    }
}

struct GoalsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        GoalsListView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
