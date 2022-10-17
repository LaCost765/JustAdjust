//
//  GoalView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalView: View {
    
    let model: any GoalViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                Text(model.goalText)
                    .padding()
                    .font(.title.bold())
                Spacer()
                Image(model.priorityIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.trailing)
                    .padding(.top)
            }

            HStack {
                HStack(spacing: 4) {
                    Text("\(model.daysInRow)")
                        .font(.title2.bold())
                    Text(model.formattedDaysInRow)
                        .font(.title3.bold())
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.frequency)
                        .font(.caption)
                    Text(model.formattedEndDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = GoalModel(
            text: "Сделать 50 отжиманий утром, еще 50 вечером",
            daysInRow: 65,
            frequencyMode: .weekdays,
            priorityMode: .middle,
            endDate: Date()
        )
        
        GoalView(model: model)
            .background(Color.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
}
