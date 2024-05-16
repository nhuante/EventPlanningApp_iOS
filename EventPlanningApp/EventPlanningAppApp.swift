//
//  EventPlanningAppApp.swift
//  EventPlanningApp
//
//  Created by Natalie Huante on 5/15/24.
//

import SwiftUI

@main
struct EventPlanningAppApp: App {
    @StateObject var eventPlanner = EventPlanner()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(eventPlanner)
        }
    }
}
