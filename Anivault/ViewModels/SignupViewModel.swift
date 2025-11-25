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
                let request = RegisterRequest(username: email, email: email, password: password)
                let response = try await authService.register(request: request)

                // Save token (simplified for this task, ideally use Keychain)
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")

                isAuthenticated = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
