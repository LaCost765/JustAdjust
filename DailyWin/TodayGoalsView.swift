//
//  TodayGoalsView.swift
//  DailyWin
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI

struct TodayGoalsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(goals.filter { $0.isNeedToday} ) { goal in
                    GoalView(model: goal)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .onTapGesture {
                            showAlert = true
                        }
                        .alert("Вы выполнили цель?", isPresented: $showAlert) {
                            Button("Отмена") { }
                            Button("Да") {
                                setGoalCompleted(goal: goal)
                            }
                        }
                }
                .padding(.horizontal)
            }
            .navigationTitle("На сегодня")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func setGoalCompleted(goal: Goal) {
        withAnimation {
            goal.lastCompleteDate = .now
        }
    }
}

struct TodayGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalsView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
