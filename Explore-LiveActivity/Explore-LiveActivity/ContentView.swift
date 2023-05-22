//
//  ContentView.swift
//  Explore-LiveActivity
//
//  Created by Abhilash Palem on 06/12/22.
//

import ActivityKit
import Combine
import SwiftUI

/*
 Links:
 
 Definition:
 Live Activity and Dynamic Island actually exist as two forms of the same widget, and they are configured using ActivityConfiguration in ActivityKit.
 
 Notes:
 - However, although Live Activities leverage WidgetKit’s functionality, they aren’t widgets. In contrast to the timeline mechanism you use to update the user interface of your widgets, you update a Live Activity from your app with ActivityKit or with remote push notifications
 
 -  The ActivityAttributes inform the system about static data that appears in the Live Activity. You also use ActivityAttributes to declare the required custom Activity.ContentState type that describes the dynamic data of your Live Activity.
 
 - Use the ActivityAttributes you defined to create the ActivityConfiguration you need to start a Live Activity
 
 - If your app already offers widgets, add the Live Activity to your WidgetBundle. If you don’t have a WidgetBundle — for example, if you only offer one widget — create a widget bundle as described in Creating a Widget Extension and then add the Live Activity to it.
 
 - The system may truncate a Live Activity on the Lock Screen if its height exceeds 160 points.
 
 - When you start a Live Activity and it’s the only active Live Activity, the compact leading and trailing views appear together to form a cohesive view in the Dynamic Island. When more than one Live Activity is active — either from your app or from multiple apps — the system chooses which Live Activities are visible and displays two using the minimal view for each: One minimal view appears attached to the Dynamic Island while the other appears detached.
 
 - By default, compact and minimal views in the Dynamic Island use a black background color with white text. Use the keylineTint(_:) modifier to apply an optional tint color to the Dynamic Island — for example, apply a cyan tint color as shown in the example below.
 
 https://ohdarling88.medium.com/update-dynamic-island-and-live-activity-with-push-notification-38779803c145
 - Unlike the normal home widgets, Live Activity does not have a timeline provider to provide a regular update mechanism, it can only rely on the App to update it actively, or rely on Push notifications to update it.
 
 - The pushToken of the Activity object is not generated instantly when the object is created, it needs to wait for some time before it has a value, so you need to wait or monitor pushTokenUpdates to get a valid value
 
 - The traditional way to connect to APNs is to use certificate-based authentication, but in connections using certificate-based authentication, even with the additional information needed to update the Live Activity, you will still encounter the TopicDisallowed error
 
 Documentation Notes:
 
 */

struct StandardBtnModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal)
            .background(Color.black)
            .cornerRadius(10.0)
    }
}

struct ContentView: View {
    @State var activity: Activity<ShuttleRideActivityAttributes>?
    @State private var cancellables = Set<AnyCancellable>()
    
    init() {
//        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
//            // terminating
//            print("terminating")
//            await MainActor.run(body: {
//                await activity?.end(dismissalPolicy: .immediate)
//            })
//        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.red, .blue], center: .center, startRadius: 0.0, endRadius: 400.0)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    let attributes = ShuttleRideActivityAttributes(title: "Shuttle is on the way!")
                    let contentState = ShuttleRideActivityAttributes.LiveRideActivityData(
                        rideMessage: "Relax, Everything is as per schedule",
                        etaText: "31 min")
                    do {
                        activity = try Activity<ShuttleRideActivityAttributes>.request(
                            attributes: attributes,
                            contentState: contentState,
                            pushType: .token)
                        Task {
                           for await data in activity!.pushTokenUpdates {
                               print("Push Token LiveActivity: \(data.hexString)")
                           }
                        }
                    } catch (let error) {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Track Shuttle")
                        .modifier(StandardBtnModifier())
                }
                
                Spacer()
                    .frame(height: 50)
                
                Button {
                    Task {
                        await activity?.end(dismissalPolicy: .immediate)
                    }
                } label: {
                    Text("End Tracking")
                        .modifier(StandardBtnModifier())
                }
            }
        }
    }
    
    func updateActivity() {
        guard let activity = activity else { return }
        Task {
            let contentState = ShuttleRideActivityAttributes.LiveRideActivityData(
                rideMessage: "Relax, Everything is as per schedule",
                etaText: "\(Int.random(in: 0..<31)) min")
            await activity.update(using: contentState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension Data {
    var hexString: String {
        let hexStr = map { String(format: "%02.2hhx", $0) }.joined()
        return hexStr
    }
}
