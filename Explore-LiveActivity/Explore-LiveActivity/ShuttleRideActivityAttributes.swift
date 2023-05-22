//
//  ShuttleRideActivityAttributes.swift
//  Explore-LiveActivity
//
//  Created by Abhilash Palem on 07/12/22.
//
import ActivityKit
import Foundation

struct ShuttleRideActivityAttributes: ActivityAttributes, Identifiable {
    
    typealias LiveRideActivityData = ContentState
    
    struct ContentState: Codable, Hashable {
        let rideMessage: String
        let etaText: String
    }
    let title: String
    var id = "UniqueID"
}
