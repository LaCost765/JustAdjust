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
        VStack {
            
            if entry.todayGoalsCount.isZero {
                VStack {
                    Text("Cоздавайте")
                    Text("Новые")
                    Text("Привычки")
                }
                .foregroundColor(.primary.opacity(0.8))
                .fontWeight(.bold)
                .font(.caption)
            } else {
                Text("\(entry.percent) %")
                    .fontWeight(.heavy)
                    .font(.title2)
                    .foregroundColor(.primary.opacity(0.8))
                Text("\(Int(entry.todayGoalsCount) - Int(entry.currentGoalsCount)) из \(Int(entry.todayGoalsCount))")
                    .font(.caption)
            }
        }
    }

    var body: some View {
        
        VStack(spacing: 16) {
            
            ZStack {
                
                LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.8)
                                
                Circle()
                    .stroke(lineWidth: 12)
                    .fill(.primary.opacity(0.7))
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(entry.progress))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .fill(Color(red: 17 / 255, green: 136 / 255, blue: 17 / 255))
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: 100, height: 100)
                
                
                goalsCountView
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
        .configurationDisplayName("Прогресс")
        .description("Контролируйте свои привычки в течение дня")
        .supportedFamilies([.systemSmall])
    }
}

struct DailyWinWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyWinWidgetEntryView(entry: WidgetEntry.example)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
