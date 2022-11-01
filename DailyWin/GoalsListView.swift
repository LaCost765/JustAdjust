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
        TabView {
            NavigationView {
                List {
                    ForEach(goals) { goal in
                        GoalView(model: goal)
                            .background(Color.secondary.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteGoals)
                }
                .listStyle(.plain)
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
            .tabItem {
                Image(systemName: "house.fill")
                Text("Цели")
            }
            
            NavigationView {
                Text("Цели на сегодня")
                    .navigationTitle("Сегодня")
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Сегодня")
            }
        }
    }
    
    func deleteGoals(at offsets: IndexSet) {
        for offset in offsets {
            let goal = goals[offset]
            moc.delete(goal)
        }
        
        try? moc.save()
    }
}

struct GoalsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        GoalsListView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
