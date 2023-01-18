//
//  HabitsListView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct HabitsListView: View {
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.progressInfo?.originStartDate, order: .reverse)
        ]
    )
    var habits: FetchedResults<Habit>
    let service: CoreDataServiceProtocol = CoreDataService.instance
    @State private var showCreateScreen = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            List {
                
                if habits.isEmpty {
                    Button("Добавить новую привычку") {
                        showCreateScreen = true
                    }
                }
                
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailsView(habit: habit)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(habit.textDescription)
                                .font(.headline)
                                .lineLimit(2)
                            Text(habit.frequencyMode.string)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteHabit(habit: habit)
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
                CreateHabitView()
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
    
    func deleteHabit(habit: Habit) {
        do {
            try service.deleteHabit(habit: habit)
        } catch {
            showErrorAlert = true
        }
    }
}

struct HabitsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        HabitsListView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
