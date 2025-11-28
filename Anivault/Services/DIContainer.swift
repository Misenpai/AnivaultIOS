import Foundation
import Combine

class DIContainer: ObservableObject {
    let authService: AuthServiceProtocol
    let tokenManager: TokenManagerProtocol

    init(
        authService: AuthServiceProtocol = AuthService(),
        tokenManager: TokenManagerProtocol = TokenManager.shared
    ) {
        self.authService = authService
        self.tokenManager = tokenManager
    }
}
