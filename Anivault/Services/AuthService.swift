import Foundation

protocol AuthServiceProtocol {
    func login(request: LoginRequest) async throws -> TokenResponse
    func signup(request: SignupRequest) async throws -> TokenResponse
    func verifyEmail(request: VerifyCodeRequest) async throws -> Bool
    func resendOTP(request: VerifyEmailRequest) async throws -> Bool
}

enum AuthError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case decodingError(Error)
    case unauthorized
    case conflict(String)
    case validationError(String)
    case emailVerificationError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let reason):
            return reason
        case .decodingError(let error):
            return "Failed to parse server response: \(error.localizedDescription)"
        case .unauthorized:
            return "Invalid credentials."
        case .conflict(let reason):
            return reason
        case .validationError(let reason):
            return reason
        case .emailVerificationError:
            return "Email not Verified"
        }
    }
}

final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    private let baseURL = Configuration.apiURL

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }

    func login(request: LoginRequest) async throws -> TokenResponse {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        return try handleResponse(data: data, statusCode: httpResponse.statusCode)
    }

    func signup(request: SignupRequest) async throws -> TokenResponse {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        return try handleResponse(data: data, statusCode: httpResponse.statusCode)
    }

    func verifyEmail(request: VerifyCodeRequest) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/auth/verify-code") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (_, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        return httpResponse.statusCode == 200
    }

    func resendOTP(request: VerifyEmailRequest) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/auth/verify-email") else {
            throw AuthError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw AuthError.networkError(error)
        }

        let (_, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        return httpResponse.statusCode == 200
    }

    private func handleResponse(data: Data, statusCode: Int) throws -> TokenResponse {
        switch statusCode {
        case 200, 201:
            do {
                return try decoder.decode(TokenResponse.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                throw AuthError.decodingError(error)
            }

        case 400:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw AuthError.validationError(errorResponse.error.message)
            }
            throw AuthError.validationError("Invalid request data.")

        case 401:
            throw AuthError.unauthorized

        case 403:
            throw AuthError.emailVerificationError

        case 409:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw AuthError.conflict(errorResponse.error.message)
            }
            throw AuthError.conflict("Email already exists.")

        default:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw AuthError.serverError(errorResponse.error.message)
            }
            throw AuthError.serverError("Server returned status \(statusCode)")
        }
    }
}
