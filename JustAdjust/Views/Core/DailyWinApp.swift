//
//  JustAdjustApp.swift
//  JustAdjust
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

@main
struct JustAdjustApp: App {
        
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, DataController.context)
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "isFirstOpen")
                }
        }
    }
}
