//
//  MainTabView.swift
//  DailyWin
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        ZStack {
            
            TabView {
                TodayGoalsView()
                    .tabItem {
                        Image(systemName: "star.fill")
                    }
                
                GoalsListView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
