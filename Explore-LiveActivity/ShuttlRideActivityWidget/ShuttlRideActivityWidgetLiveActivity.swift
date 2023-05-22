//
//  ShuttlRideActivityWidgetLiveActivity.swift
//  ShuttlRideActivityWidget
//
//  Created by Abhilash Palem on 07/12/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

@available(iOSApplicationExtension 16.1, *)
struct ShuttlRideActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShuttleRideActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            LockScreenView(context: context)
                .padding(15)
//                .activityBackgroundTint(Color.cyan)
//                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Color.blue
                        .frame(height: 55)
                        .overlay(Text("Leading").bold())
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Color.red
                        .frame(height: 55)
                        .overlay(Text("Trailing").bold())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Color.green
                        .frame(height: 10)
                        .overlay(Text("Bottom").bold())
                    // more content
                }
                DynamicIslandExpandedRegion(.center) {
                    Color.orange
                        .overlay(Text("Center").bold())
                }
            } compactLeading: {
                Color.brown
                    .frame(height: 55)
                    .overlay(Text("C Leading").bold())
            } compactTrailing: {
                Color.cyan
                    .frame(height: 55)
                    .overlay(Text("C Trailing").bold())
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
    let context: ActivityViewContext<ShuttleRideActivityAttributes>
    var body: some View {
        VStack(spacing: 10) {
            Text(context.attributes.title)
                .font(.headline)
            Text(context.state.rideMessage)
                .font(.subheadline)
            BottomView(eta: context.state.etaText)
        }
    }
}

struct BottomView: View {
    let eta: String
    var body: some View {
        HStack {
            Divider().frame(width: 50,
                            height: 10)
            .overlay(.gray).cornerRadius(5)
            Image(systemName: "bus.doubledecker")
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1,
                                               dash: [4]))
                    .frame(height: 20)
                    .overlay(Text(eta).font(.system(size: 12)).multilineTextAlignment(.center))
            }
            Image(systemName: "person.3")
        }
    }
}
