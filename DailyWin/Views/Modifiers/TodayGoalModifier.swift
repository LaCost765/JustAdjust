//
//  TodayGoalModifier.swift
//  DailyWin
//
//  Created by Egor Baranov on 06.12.2022.
//

import SwiftUI

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
