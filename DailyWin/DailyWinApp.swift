//
//  DailyWinApp.swift
//  DailyWin
//
//  Created by Egor Baranov on 16.10.2022.
//

import SwiftUI

@main
struct DailyWinApp: App {
        
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, DataController.context)
        }
    }
}
