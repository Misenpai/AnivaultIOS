import Combine
import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var identifier = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol
    private let tokenManager: TokenManagerProtocol
    private let coordinator: AppCoordinator
    private let appState: AnivaultAppState

    init(container: DIContainer, coordinator: AppCoordinator, appState: AnivaultAppState) {
        self.authService = container.authService
        self.tokenManager = container.tokenManager
        self.coordinator = coordinator
        self.appState = appState
    }

    func login() {
        guard !identifier.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username/email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let request = LoginRequest(identifier: identifier, password: password)
                let response = try await authService.login(request: request)

                // Save token securely
                _ = tokenManager.save(token: response.accessToken, for: "accessToken")

                // Update AppState
                appState.isAuthenticated = true
                appState.currentUser = response.user

                // Navigate to Home
                coordinator.setRoot(.home)

            } catch AuthError.emailVerificationError {
                // Handle unverified email
                if identifier.contains("@") {
                    // Assume identifier is email
                    do {
                        _ = try await authService.resendOTP(
                            request: VerifyEmailRequest(email: identifier))
                        coordinator.navigate(to: .otpVerification(email: identifier))
                    } catch {
                        errorMessage = "Failed to resend OTP: \(error.localizedDescription)"
                    }
                } else {
                    errorMessage = "Account not verified. Please login with email to verify."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func navigateToSignup() {
        coordinator.navigate(to: .signup)
    }
}
