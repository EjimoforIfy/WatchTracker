//
//  WatchTrackerApp.swift
//  WatchTracker Watch App
//
//  Created by Ejimofor I J (FCES) on 18/02/2026.
//

import SwiftUI

@main
struct WaterTrackerWatchApp: App {
    @State var tracker = TrackerModel()

    var body: some Scene {
        WindowGroup {
            ContentView(tracker: tracker)
        }
    }
}

