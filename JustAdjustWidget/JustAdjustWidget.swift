//
//  JustAdjustWidget.swift
//  JustAdjustWidget
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
    
    var percent: Int {
        Int(progress * 100)
    }
    
    var goalsCompleted: Bool {
        currentGoalsCount.isZero
    }
    
    static let example = WidgetEntry(
        date: .now,
        todayGoalsCount: 0,
        currentGoalsCount: 0
    )
}

struct JustAdjustWidgetEntryView : View {
    
    var entry: WidgetEntry
    
    var titleText: String {
        if entry.goalsCompleted {
            return "Цели выполнены"
        } else {
            return "Осталось целей"
        }
    }
    
    var goalsCountView: some View {
        VStack {
            
            if entry.todayGoalsCount.isZero {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
                    .frame(width: 40, height: 40)
            } else {
                Text("\(entry.percent) %")
                    .fontWeight(.heavy)
                    .font(.title)
                    .foregroundStyle(.primary)
                
                Text("\(Int(entry.todayGoalsCount) - Int(entry.currentGoalsCount)) из \(Int(entry.todayGoalsCount))")
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
            }
        }
    }

    var body: some View {
        
        VStack(spacing: 16) {
            
            ZStack {
                
                ViewConstats.gradient.opacity(0.3)
                                
                Circle()
                    .stroke(lineWidth: 14)
                    .fill(.secondary.opacity(0.5))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(entry.progress))
                    .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
                    .fill(.green)
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: 120, height: 120)
                
                goalsCountView
            }
        }
    }
}

@main
struct JustAdjustWidget: Widget {
    let kind: String = "JustAdjustWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            JustAdjustWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Прогресс")
        .description("Контролируйте свои привычки в течение дня")
        .supportedFamilies([.systemSmall])
    }
}

struct JustAdjustWidget_Previews: PreviewProvider {
    static var previews: some View {
        JustAdjustWidgetEntryView(entry: WidgetEntry.example)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
