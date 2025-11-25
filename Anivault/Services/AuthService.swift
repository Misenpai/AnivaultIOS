import Foundation

protocol AuthServiceProtocol {
    func login(request: LoginRequest) async throws -> TokenResponse
    func register(request: RegisterRequest) async throws -> TokenResponse
}

enum AuthError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case decodingError(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL configuration."
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid response from server."
        case .serverError(let reason): return reason
        case .decodingError: return "Failed to parse server response."
        case .unauthorized: return "Invalid credentials."
        }
    }
}

final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    private let baseURL = Configuration.apiURL

    func login(request: LoginRequest) async throws -> TokenResponse {
        guard let url = URL(string: "\(baseURL)/login") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        if httpResponse.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                // Handle date decoding if needed, standard ISO8601 is usually default but Vapor might use specific format
                // For now assuming standard ISO8601 or double
                // Let's check TokenResponse.swift in backend... it uses Date.
                // Vapor default JSON encoder uses ISO8601.
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .iso8601

                return try decoder.decode(TokenResponse.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw AuthError.decodingError(error)
            }
        } else if httpResponse.statusCode == 401 {
            throw AuthError.unauthorized
        } else {
            // Try to decode error reason
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw AuthError.serverError(errorResponse.reason)
            }
            throw AuthError.serverError("Server returned status \(httpResponse.statusCode)")
        }
    }

    func register(request: RegisterRequest) async throws -> TokenResponse {
        guard let url = URL(string: "\(baseURL)/register") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(TokenResponse.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw AuthError.decodingError(error)
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw AuthError.serverError(errorResponse.reason)
            }
            throw AuthError.serverError("Server returned status \(httpResponse.statusCode)")
        }
    }
}
