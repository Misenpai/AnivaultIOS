import Combine
import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var identifier = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    @Published var showOTPVerification = false

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
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
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")

                isAuthenticated = true
            } catch AuthError.emailVerificationError {
                // Handle unverified email
                if identifier.contains("@") {
                    // Assume identifier is email
                    do {
                        _ = try await authService.resendOTP(
                            request: VerifyEmailRequest(email: identifier))
                        showOTPVerification = true
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
}
