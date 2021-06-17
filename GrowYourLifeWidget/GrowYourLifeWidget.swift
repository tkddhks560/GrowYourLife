//
//  GrowYourLifeWidget.swift
//  GrowYourLifeWidget
//
//  Created by 이상완 on 2021/06/18.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct GrowYourLifeWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if family == .systemSmall {
            GrowYourLifeWidgetSamll()
        } else {
            GrowYourLifeWidgetMedium()
        }
    }
}

struct GrowYourLifeWidgetSamll: View {
    
    var body: some View {
        Image("tree_0_10")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .padding(12)
    }
}

struct GrowYourLifeWidgetMedium: View {
    
    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading) {
                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Read")
                Text("10 pages")
                    .font(Font.footnote)
                    .foregroundColor(.secondary)
                
                Text("성장까지 남은 횟수 3번")
                    .font(Font.footnote.smallCaps())
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
            Image("tree_0_10")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:150, height: 150)
            
        }
        .padding(12)
    }
}





@main
struct GrowYourLifeWidget: Widget {
    let kind: String = "GrowYourLifeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GrowYourLifeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("자기 계발하고 캐릭터를 성장시켜주세요!")
        .description("오늘 할 것!.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct GrowYourLifeWidget_Previews: PreviewProvider {
    static var previews: some View {
        GrowYourLifeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
