//
//  GoalView.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalView: View {
    
    let model: Goal
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                Text(model.wrappedText)
                    .padding()
                    .font(.title.bold())
                Spacer()
                Image(model.priorityMode.iconName)
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
                    Text(model.frequencyMode.rawValue)
                        .font(.caption)
                    Text("Дата начала")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

//struct GoalView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        GoalView(model: model)
//            .background(Color.secondary.opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .padding(.horizontal)
//    }
//}
