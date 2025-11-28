//
// AnivaultApp.swift
// Anivault
//
// Created by Sumit Sinha on 24/11/25.
//

import SwiftUI

@main
struct AnivaultApp: App {
    @StateObject private var container = DIContainer()
    @StateObject private var appState: AnivaultAppState
    @StateObject private var coordinator = AppCoordinator()

    init() {
        let container = DIContainer()
        _container = StateObject(wrappedValue: container)
        _appState = StateObject(
            wrappedValue: AnivaultAppState(tokenManager: container.tokenManager))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                Group {
                    if appState.isAuthenticated {
                        LandingView()
                    } else {
                        LoginView(
                            container: container, coordinator: coordinator, appState: appState)
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView(
                            container: container, coordinator: coordinator, appState: appState)
                    case .signup:
                        SignupView(container: container, coordinator: coordinator)
                    case .otpVerification(let email):
                        OTPVerificationView(email: email, authService: container.authService)
                    case .home:
                        LandingView()
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(container)
            .environmentObject(coordinator)
        }
    }
}
