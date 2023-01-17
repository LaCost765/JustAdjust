//
//  DefaultAlertModifier.swift
//  JustAdjust
//
//  Created by Egor Baranov on 06.12.2022.
//

import SwiftUI

struct DefaultAlertModifier: ViewModifier {
   
    let isPresented: Binding<Bool>
    let title: String
    let message: String
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: isPresented,
                actions: { },
                message: {
                    Text(message)
                }
            )
    }
}

extension View {
    
    func defaultAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String
    ) -> some View {
        let style = DefaultAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message
        )
        
        return modifier(style)
    }
}
