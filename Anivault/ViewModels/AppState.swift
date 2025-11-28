import Combine
import Foundation
import SwiftUI

class AnivaultAppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserDTO?

    private let tokenManager: TokenManagerProtocol

    init(tokenManager: TokenManagerProtocol = TokenManager.shared) {
        self.tokenManager = tokenManager
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if tokenManager.get(for: "accessToken") != nil {
            isAuthenticated = true
            // Ideally, we would also fetch the user profile here
        } else {
            isAuthenticated = false
        }
    }

    func logout() {
        _ = tokenManager.delete(for: "accessToken")
        isAuthenticated = false
        currentUser = nil
    }
}
