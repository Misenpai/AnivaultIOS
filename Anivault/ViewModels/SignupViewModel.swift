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
    @Published var isAuthenticated = false

    @Published var showOTPVerification = false

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
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
                showOTPVerification = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
