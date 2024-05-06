//
//  smiraddWidgetLiveActivity.swift
//  smiraddWidget
//
//  Created by Минь Дык Фам on 06.05.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct smiraddWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct smiraddWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: smiraddWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension smiraddWidgetAttributes {
    fileprivate static var preview: smiraddWidgetAttributes {
        smiraddWidgetAttributes(name: "World")
    }
}

extension smiraddWidgetAttributes.ContentState {
    fileprivate static var smiley: smiraddWidgetAttributes.ContentState {
        smiraddWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: smiraddWidgetAttributes.ContentState {
         smiraddWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: smiraddWidgetAttributes.preview) {
   smiraddWidgetLiveActivity()
} contentStates: {
    smiraddWidgetAttributes.ContentState.smiley
    smiraddWidgetAttributes.ContentState.starEyes
}
