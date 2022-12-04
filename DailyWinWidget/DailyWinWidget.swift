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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    
        let firstDate = Calendar.current.startOfDay(for: .now)
        let firstEntry = SimpleEntry(date: firstDate)
        
        let secondDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate)!
        let secondEntry = SimpleEntry(date: secondDate)

        let timeline = Timeline(entries: [firstEntry, secondEntry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DailyWinWidgetEntryView : View {
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: .init(
            format: "lastActionDate == nil OR lastActionDate < %@", Date.now.date as NSDate
        ),
        animation: .easeIn
    )
    var goals: FetchedResults<Goal>
    
    var todayGoals: [Goal] {
        goals.filter { $0.isNeedToday() }
    }
    
    var titleText: String {
        if todayGoals.isEmpty {
            return "Цели выполнены"
        } else {
            return "Осталось целей"
        }
    }
    
    var goalsCountView: some View {
        Text("\(todayGoals.count)")
            .fontWeight(.heavy)
            .font(.title)
            .foregroundColor(.primary.opacity(0.6))
    }
    
    var goalsCompletedView: some View {
        Image(systemName: "checkmark")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.green)
    }
    
    var entry: Provider.Entry

    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(titleText)
                .fontWeight(.light)
            
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.green)
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: 80, height: 80)
                
                if todayGoals.isEmpty {
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DailyWinWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyWinWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
