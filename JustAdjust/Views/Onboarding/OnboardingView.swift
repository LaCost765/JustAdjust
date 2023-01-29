//
//  OnboardingView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 23.01.2023.
//

import SwiftUI

struct OnboardingCellView: View {
    
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
                    .font(.title3)
                
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("Привыкай: легко и просто!")
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.bottom)
                    .padding(.top, 40)
                
                OnboardingCellView(
                    imageName: "brain.head.profile",
                    title: "Формируйте привычки",
                    subtitle: "Настройте необходимые параметры и отслеживайте прогресс."
                )
                .padding(.vertical)
                
                OnboardingCellView(
                    imageName: "chart.line.uptrend.xyaxis",
                    title: "Ставьте личные рекорды",
                    subtitle: "Не забывайте отмечаться в приложении и покоряйте новые вершины."
                )
                .padding(.bottom)
                
                OnboardingCellView(
                    imageName: "rectangle.3.group.fill",
                    title: "Устанавливайте виджет",
                    subtitle: "Настройте привычки один раз и забудьте, контролируйте их с помощью виджета"
                )
                .padding(.bottom)
            }
            .padding(.horizontal, 24)
            
            
            Button(action: { dismiss() }) {
                Text("Понятно")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.vertical)
            .padding(.horizontal, 24)
        }
        .background(.secondary.opacity(0.1))
        .onAppear {
            UserDefaults.standard.set(true, forKey: String.didShowOnboardingKey)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
