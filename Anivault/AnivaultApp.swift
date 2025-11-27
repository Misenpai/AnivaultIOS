//
// AnivaultApp.swift
// Anivault
//
// Created by Sumit Sinha on 24/11/25.
//

import SwiftUI

@main
struct AnivaultApp: App {
    @StateObject private var appState = AnivaultAppState()

    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                LandingView()
                    .environmentObject(appState)
            } else {
                LoginView()
                    .environmentObject(appState)
            }
        }
    }
}
