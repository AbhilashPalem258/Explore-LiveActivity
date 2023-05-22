//
//  Explore_LiveActivityApp.swift
//  Explore-LiveActivity
//
//  Created by Abhilash Palem on 06/12/22.
//
import ActivityKit
import SwiftUI
import BackgroundTasks
import UserNotifications

// https://betterprogramming.pub/ios-live-activities-updating-remotely-using-push-notification-34911a1bcc5e

@main
struct Explore_LiveActivityApp: App {
    
    @Environment(\.scenePhase) var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("onOpenURL: \(url)")
                }
        }
//        .onChange(of: phase) { newPhase in
//            if newPhase == .background {
//                if Activity<ShuttleRideActivityAttributes>.activities.first != nil {
//                    TrackShuttleActivityHandler.scheduleNextBGTask(after: 0)
//                }
//                print("Breakpoint here to simulate live activity")
//            }
//        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let notify = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let options: UNAuthorizationOptions = [
            .badge,
            .alert,
            .sound
        ]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { status, error in
            if status {
                UNUserNotificationCenter.current().delegate = self.notify
            }
        }
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.shuttl.ios.liveactivity.trackshuttl", using: nil) { task in
//            if let appRefreshtask = task as? BGAppRefreshTask {
//                TrackShuttleActivityHandler.fetchETA(task: appRefreshtask)
//            }
//        }
        return true
    }
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("Received Notification with response: \(response)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("WillPresent Notification with notification: \(notification)")
        completionHandler([.banner, .sound, .badge])
    }
}
