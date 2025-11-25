import Combine
import Foundation
import SwiftUI

@MainActor
class OTPVerificationViewModel: ObservableObject {
    @Published var otp = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isVerified = false

    let email: String
    private let authService: AuthServiceProtocol

    init(email: String, authService: AuthServiceProtocol) {
        self.email = email
        self.authService = authService
    }

    func verify() {
        guard otp.count == 6 else {
            errorMessage = "Please enter a valid 6-digit code."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let request = VerifyCodeRequest(email: email, code: otp)
                let success = try await authService.verifyEmail(request: request)

                if success {
                    isVerified = true
                } else {
                    errorMessage = "Verification failed. Please try again."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
