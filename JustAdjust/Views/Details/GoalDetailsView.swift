//
//  HabitDetailsView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 07.11.2022.
//

import SwiftUI

struct HabitDetailsView: View {
    
    @ObservedObject var habit: Habit
    
    var body: some View {
        List {
            
            Section {
                Text(habit.textDescription)
                    .font(.title2)
                    .bold()
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
                    Text(habit.frequencyMode.string)
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
                    Text(habit.priorityMode.string)
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
                    Text(habit.progressFormattedString)
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
                    Text("\(habit.bestResult)")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Прогресс")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView(habit: DataController.testHabit)
    }
}
