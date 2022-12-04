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
            format: "lastActionDate == nil OR lastActionDate < %@", Date.now.date as NSDate
        ),
        animation: .easeIn
    )
    var goals: FetchedResults<Goal>
    
    var todayGoals: [Goal] {
        goals.filter { $0.isNeedToday() }
    }
    
    @State private var selectedGoal: Goal?
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var stubViewOpacity: Double = 0
    
    private var overlay: some View {
        ZStack {
            LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
            HStack {
                Spacer()
                Button(action: markGoalUncompleted) {
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
    
    private var stubView: some View {
        VStack(spacing: 6) {
            Text("Нет актуальных целей")
                .font(.title)
                .foregroundColor(.secondary)
            Button {
                showAlert = true
            } label: {
                Text("Почему?")
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(todayGoals) { goal in
                        GoalView(model: goal)
                            .todayCardStyle(isSelected: goal == selectedGoal, isOverlayShown: showOverlay)
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
                
                if todayGoals.isEmpty {
                    stubView
                        .opacity(stubViewOpacity)
                        .onAppear {
                            withAnimation {
                                stubViewOpacity = 1
                            }
                        }
                }
            }
            .navigationTitle("На сегодня")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Почему нет целей?", isPresented: $showAlert, actions: {
            Text("Хорошо")
        }, message: {
            Text("Скорее всего вы уже выполнили все цели на сегодня. Если нет, перейдите на другой экран и создайте новые")
        })
    }
    
    func markGoalCompleted() {
        withAnimation(.default.delay(0.2)) {
            selectedGoal = nil
            showOverlay = false
        }
        try? moc.save()
    }
    
    func markGoalUncompleted() {
        withAnimation(.default.delay(0.2)) {
            selectedGoal = nil
            showOverlay = false
        }
        try? moc.save()
    }
}

struct TodayGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalsView()
            .environment(\.managedObjectContext, DataController.context)
    }
}

struct TodayGoalModifier: ViewModifier {
   
    let isGoalSelected: Bool
    let showOverlay: Bool
    
    var blurAmount: CGFloat {
        isGoalSelected && showOverlay ? 3 : 0
    }
    
    var scaleAmount: CGFloat {
        isGoalSelected ? 1 : 0.97
    }
    
    var shadowAmount: CGFloat {
        isGoalSelected ? 10 : 0
    }
    
    func body(content: Content) -> some View {
        content
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .blur(radius: blurAmount)
            .scaleEffect(scaleAmount)
            .shadow(color: .secondary, radius: shadowAmount)
            .transition(.scale)
    }
}

extension View {
    
    func todayCardStyle(
        isSelected: Bool,
        isOverlayShown: Bool
    ) -> some View {
        let style = TodayGoalModifier(
            isGoalSelected: isSelected,
            showOverlay: isOverlayShown
        )
        return modifier(style)
    }
}
