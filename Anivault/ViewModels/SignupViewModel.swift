import Combine
import Foundation
import SwiftUI

@MainActor
class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol
    private let coordinator: AppCoordinator

    init(container: DIContainer, coordinator: AppCoordinator) {
        self.authService = container.authService
        self.coordinator = coordinator
    }

    func register() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let request = SignupRequest(email: email, password: password)
                _ = try await authService.signup(request: request)

                // Navigate to OTP screen
                coordinator.navigate(to: .otpVerification(email: email))
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func navigateToLogin() {
        coordinator.goBack()
    }
}
