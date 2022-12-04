//
//  GoalsListView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalsListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @State private var showCreateScreen = false
    
    var body: some View {
        NavigationView {
            List {
                
                if goals.isEmpty {
                    Button("Добавить цель") {
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
            .navigationTitle("Цели")
            .sheet(isPresented: $showCreateScreen) {
                CreateGoalView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
        moc.delete(goal)
        try? moc.save()
    }
}

struct GoalsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        GoalsListView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
