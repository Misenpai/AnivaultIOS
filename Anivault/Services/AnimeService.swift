import Foundation

protocol AnimeServiceProtocol {
    func fetchCurrentSeasonAnime(page: Int) async throws -> SeasonAnimeResponse
}

final class AnimeService: AnimeServiceProtocol {
    private let baseURL = Configuration.apiURL
    private let tokenManager: TokenManagerProtocol

    init(tokenManager: TokenManagerProtocol = TokenManager.shared) {
        self.tokenManager = tokenManager
    }

    func fetchCurrentSeasonAnime(page: Int) async throws -> SeasonAnimeResponse {
        guard let url = URL(string: "\(baseURL)/anime/season/now?page=\(page)") else {
            throw AuthError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add Auth Token
        if let token = tokenManager.get(for: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw AuthError.unauthorized
            }
            throw AuthError.serverError("Server returned status \(httpResponse.statusCode)")
        }

        let decoder = JSONDecoder()
        return try decoder.decode(SeasonAnimeResponse.self, from: data)
    }
}
