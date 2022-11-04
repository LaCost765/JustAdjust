//
//  GoalsListView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalsListView: View {
    
    @State private var showCreateScreen = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    
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
                        Text("\(Date().getNumberOfWeekDay())")
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(goal.wrappedText)
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
                Button {
                    showCreateScreen = true
                } label: {
                    Image(systemName: "plus")
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
