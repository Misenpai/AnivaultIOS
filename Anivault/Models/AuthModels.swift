import Foundation

// MARK: - Requests

struct LoginRequest: Encodable {
    let identifier: String
    let password: String
}

struct RegisterRequest: Encodable {
    let username: String
    let email: String
    let password: String
}

// MARK: - Responses

struct TokenResponse: Decodable {
    let success: Bool
    let accessToken: String
    let refreshToken: String
    let user: UserDTO
    let expiresAt: Date
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case success
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
        case expiresAt = "expires_at"
        case tokenType = "token_type"
    }
}

struct UserDTO: Decodable, Identifiable {
    let id: UUID?
    let email: String
    let username: String
    let roleId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case roleId = "role_id"
    }
}

struct ErrorResponse: Decodable {
    let error: Bool
    let reason: String
}
