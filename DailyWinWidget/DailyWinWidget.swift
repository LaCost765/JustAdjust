//
//  DailyWinWidget.swift
//  DailyWinWidget
//
//  Created by Egor Baranov on 24.11.2022.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry.example
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        completion(WidgetEntry.example)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    
        let firstDate = Calendar.current.startOfDay(for: .now)
        let firstEntry = WidgetEntry(
            date: firstDate,
            todayGoalsCount: CoreDataService.instance.getGoalsCountForToday(),
            currentGoalsCount: CoreDataService.instance.getUncompletedGoalsCountForToday()
        )
        
        let secondDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate)!
        let secondEntry = WidgetEntry(
            date: secondDate,
            todayGoalsCount: CoreDataService.instance.getGoalsCountForToday(),
            currentGoalsCount: CoreDataService.instance.getUncompletedGoalsCountForToday()
        )

        let timeline = Timeline(entries: [firstEntry, secondEntry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let todayGoalsCount: Double
    let currentGoalsCount: Double
    
    var progress: Double {
        (todayGoalsCount - currentGoalsCount) / todayGoalsCount
    }
    
    var goalsCompleted: Bool {
        currentGoalsCount.isZero
    }
    
    static let example = WidgetEntry(
        date: .now,
        todayGoalsCount: 5,
        currentGoalsCount: 0
    )
}

struct DailyWinWidgetEntryView : View {
    
    var entry: WidgetEntry
    
    var titleText: String {
        if entry.goalsCompleted {
            return "Цели выполнены"
        } else {
            return "Осталось целей"
        }
    }
    
    var goalsCountView: some View {
        Text(entry.currentGoalsCount, format: .number)
            .fontWeight(.heavy)
            .font(.title)
            .foregroundColor(.primary.opacity(0.6))
    }
    
    var goalsCompletedView: some View {
        Image(systemName: "checkmark")
            .resizable()
            .frame(width: 34, height: 30)
            .foregroundColor(.green)
            .fontWeight(.heavy)
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(titleText)
                .fontWeight(.light)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green.opacity(0.5))
                
                Circle()
                    .trim(from: 0, to: CGFloat(entry.progress))
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.green)
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: 80, height: 80)
                
                if entry.goalsCompleted {
                    goalsCompletedView
                } else {
                    goalsCountView
                }
            }
        }
    }
}

@main
struct DailyWinWidget: Widget {
    let kind: String = "DailyWinWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyWinWidgetEntryView(entry: entry)
        }
    }
}

struct DailyWinWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyWinWidgetEntryView(entry: WidgetEntry.example)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
