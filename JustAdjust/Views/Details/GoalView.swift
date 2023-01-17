//
//  GoalView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

struct GoalView: View {
    
    let model: Goal
    
    var progressDescriptionView: some View {
        HStack(spacing: 4) {
            
            let progressInDays = model.getCurrentProgressInDays()
            let daysDescription = model.getDaysDescription(for: progressInDays)
            
            Text(String(progressInDays))
                .font(.title2.bold())
            Text(daysDescription)
                .font(.title3.bold())
                .foregroundColor(.secondary)
        }
    }
    
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
                progressDescriptionView
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.frequencyMode.rawValue)
                        .font(.caption)
                    Text(model.originStartDateString)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}