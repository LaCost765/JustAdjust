//
//  MainTabView.swift
//  JustAdjust
//
//  Created by Egor Baranov on 04.11.2022.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: Int = 1
    @State private var showOnboarding: Bool = !UserDefaults.standard.bool(forKey: "wasOpened")
    
    var body: some View {
        
        ZStack {
            
            TabView(selection: $selectedTab) {
                TodayHabitsView()
                    .tabItem {
                        Image(systemName: "star.fill")
                    }
                    .tag(1)
                
                HabitsListView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(2)
            }
        }
        .onChange(of: scenePhase, perform: { phase in
            if phase == .active {
                CoreDataService.instance.refresh()
            }
        })
        .onOpenURL { url in
            guard url.scheme == "justAdjust"
            else { return }
            withAnimation {
                selectedTab = 1
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.managedObjectContext, DataController.context)
    }
}
