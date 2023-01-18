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
            todayHabitsCount: CoreDataService.instance.getHabitsCountForToday(),
            currentHabitsCount: CoreDataService.instance.getUncompletedHabitsCountForToday()
        )
        
        let secondDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate)!
        let secondEntry = WidgetEntry(
            date: secondDate,
            todayHabitsCount: CoreDataService.instance.getHabitsCountForToday(),
            currentHabitsCount: CoreDataService.instance.getUncompletedHabitsCountForToday()
        )

        let timeline = Timeline(entries: [firstEntry, secondEntry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let todayHabitsCount: Double
    let currentHabitsCount: Double
    
    var progress: Double {
        (todayHabitsCount - currentHabitsCount) / todayHabitsCount
    }
    
    var percent: Int {
        Int(progress * 100)
    }
    
    var habitsCompleted: Bool {
        currentHabitsCount.isZero
    }
    
    static let example = WidgetEntry(
        date: .now,
        todayHabitsCount: 0,
        currentHabitsCount: 0
    )
}

struct JustAdjustWidgetEntryView : View {
    
    var entry: WidgetEntry
    
    var titleText: String {
        if entry.habitsCompleted {
            return "Цели выполнены"
        } else {
            return "Осталось целей"
        }
    }
    
    var habitsCountView: some View {
        VStack {
            
            if entry.todayHabitsCount.isZero {
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
                
                Text("\(Int(entry.todayHabitsCount) - Int(entry.currentHabitsCount)) из \(Int(entry.todayHabitsCount))")
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
                
                habitsCountView
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
