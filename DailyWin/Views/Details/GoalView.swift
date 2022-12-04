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
                Text(model.textDescription)
                    .padding()
                    .font(.title.bold())
                Spacer()
                Image(systemName: "flame.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.trailing)
                    .padding(.top)
                    .foregroundColor(model.priorityMode.iconColor)
            }

            HStack {
                HStack(spacing: 4) {
                    Text("\(model.getCurrentProgressInDays())")
                        .font(.title2.bold())
                    Text(model.getDaysDescription(for: model.getCurrentProgressInDays()))
                        .font(.title3.bold())
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.frequencyMode.rawValue)
                        .font(.caption)
                    Text(model.progressInfo?.originStartDate?.getFormatted(dateStyle: .medium, timeStyle: .none) ?? "")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}
