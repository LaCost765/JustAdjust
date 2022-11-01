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
            GoalsListView()
                .environment(\.managedObjectContext, DataController.context)
        }
    }
}
