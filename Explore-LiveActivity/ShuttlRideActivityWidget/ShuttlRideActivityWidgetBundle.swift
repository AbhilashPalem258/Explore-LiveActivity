//
//  ShuttlRideActivityWidgetBundle.swift
//  ShuttlRideActivityWidget
//
//  Created by Abhilash Palem on 07/12/22.
//

import WidgetKit
import SwiftUI

@main
struct ShuttlRideActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            ShuttlRideActivityWidgetLiveActivity()
        }
    }
}
