//
//  TrackShuttleActivityHandler.swift
//  Explore-LiveActivity
//
//  Created by Abhilash Palem on 07/12/22.
//

import Foundation
import ActivityKit
import BackgroundTasks
import UserNotifications

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum TrackShuttleActivityHandler {
    static func fetchETA(task: BGAppRefreshTask) {
//        task.expirationHandler = {
//            task.setTaskCompleted(success: false)
//        }
//
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//

        scheduleNextBGTask(after: 10)
        let queue = OperationQueue()
         queue.maxConcurrentOperationCount = 1

         queue.addOperation {
             let content = UNMutableNotificationContent()
             content.title = "BG Title"
             content.body = "BG body"
             content.subtitle = "BG Subtitle"
             content.sound = .defaultCritical
             
             UNUserNotificationCenter.current().add(.init(identifier: "NotifyId", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)))
             task.setTaskCompleted(success: true)
         }

         let lastOp = queue.operations.last
         lastOp?.completionBlock = {
           task.setTaskCompleted(success: !lastOp!.isCancelled)
         }

         task.expirationHandler = {
           queue.cancelAllOperations()
         }
//        Task {
//            do {
//                task.expirationHandler = {
//                    print("Task Expiration Handler")
//                }
//
//                let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//                let data = try await URLSession.shared.data(from: url).0
//                let posts = try JSONDecoder().decode([Post].self, from: data)
//
//                if let activity = Activity<ShuttleRideActivityAttributes>.activities.first {
//
//                    task.setTaskCompleted(success: true)
//                    scheduleNextBGTask(after: 5)
//
//                    await activity.update(using: .init(
//                        rideMessage: "[BG] Relax, Everything is as per schedule",
//                        etaText: "\(Int.random(in: 0..<60)) Min"))
//                }
//            } catch {
//                print("error: \(error)")
//            }
//        }
    }
    
    static func scheduleNextBGTask(after time: TimeInterval) {
        let bgReq = BGAppRefreshTaskRequest(identifier: "com.shuttl.ios.liveactivity.trackshuttl")
        bgReq.earliestBeginDate = Date(timeIntervalSinceNow: 5)
        do {
            try BGTaskScheduler.shared.submit(bgReq)
            print("BG sche")
        } catch {
            print("Failed to schedule BG task: \(error)")
        }
    }
}
