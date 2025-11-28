import Combine
import Foundation

class DIContainer: ObservableObject {
    let authService: AuthServiceProtocol
    let tokenManager: TokenManagerProtocol
    let animeService: AnimeServiceProtocol

    init(
        authService: AuthServiceProtocol = AuthService(),
        tokenManager: TokenManagerProtocol = TokenManager.shared,
        animeService: AnimeServiceProtocol = AnimeService()
    ) {
        self.authService = authService
        self.tokenManager = tokenManager
        self.animeService = animeService
    }
}
