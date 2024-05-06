//
//  smiraddWidget.swift
//  smiraddWidget
//
//  Created by Минь Дык Фам on 06.05.2024.
//

import WidgetKit
import SwiftUI
import CoreImage.CIFilterBuiltins

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct smiraddWidgetEntryView : View {
    var entry: Provider.Entry
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    var body: some View {
        VStack {
                Spacer().frame(height: 4) // Adjusting spacing for a 2x2 widget
                Image(
                    uiImage: generateQRCode(
                        from: "smiradd://vizme.pro?id=1"
                    )
                )
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(
                    width: 110, // Adjusting width for a 2x2 widget
                    height: 110  // Adjusting height for a 2x2 widget
                )
                Spacer().frame(height: 4) // Adjusting spacing for a 2x2 widget
                Text("Арт-директор Ozon")
                    .font(.custom("OpenSans-Bold", size: 16)) // Adjusting font size
                    .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                Spacer().frame(height: 4) // Adjusting spacing for a 2x2 widget
            }
            .padding(7)
            .background(Color.white)
            .cornerRadius(12)
    }
}

struct smiraddWidget: Widget {
    let kind: String = "smiraddWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            smiraddWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    smiraddWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
