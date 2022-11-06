//
//  TodayGoalsView.swift
//  DailyWin
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI
import CoreData

struct TodayGoalsView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: .init(
            format: "lastCompleteDate == nil OR lastCompleteDate < %@", Date.now.date as NSDate
        ),
        animation: .easeIn
    )
    var goals: FetchedResults<Goal>
    
    @State private var selectedGoal: Goal?
    @State private var showOverlay = false
    
    private var overlay: some View {
        ZStack {
            LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
            HStack {
                Spacer()
                Button(action: markGoalCompleted) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
                Spacer()
                Button(action: markGoalCompleted) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(goals) { goal in
                    
                    GoalView(model: goal)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .blur(radius: goal == selectedGoal && showOverlay ? 3 : 0)
                        .scaleEffect(goal == selectedGoal ? 1 : 0.97)
                        .shadow(color: .secondary, radius: goal == selectedGoal ? 10 : 0)
                        .transition(.scale)
                        .onTapGesture {
                            withAnimation {
                                if selectedGoal == nil {
                                    selectedGoal = goal
                                } else if selectedGoal == goal {
                                    showOverlay = true
                                } else {
                                    selectedGoal = nil
                                    showOverlay = false
                                }
                            }
                        }
                        .overlay {
                            if showOverlay, goal == selectedGoal { overlay }
                        }
                }
                .padding(.horizontal)
            }
            .navigationTitle("На сегодня")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func markGoalCompleted() {
        withAnimation(.default.delay(0.2)) {
            selectedGoal?.lastCompleteDate = .now.date
            selectedGoal = nil
            showOverlay = false
        }
//        try? moc.save()
    }
}

struct TodayGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalsView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
