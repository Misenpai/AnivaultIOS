import Foundation

// MARK: - Requests

struct LoginRequest: Encodable {
    let identifier: String
    let password: String
}

struct SignupRequest: Encodable {
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
    let email: String
    let username: String
    let roleId: Int
    let emailVerified: Bool
    let createdAt: Date?
    let lastLogin: Date?
    
    var id: String { email }

    enum CodingKeys: String, CodingKey {
        case email
        case username
        case roleId = "roleId"
        case emailVerified = "emailVerified"
        case createdAt = "createdAt"
        case lastLogin = "lastLogin"
    }
}

struct ErrorResponse: Decodable {
    let success: Bool
    let error: ErrorDetail
    
    struct ErrorDetail: Decodable {
        let code: String
        let message: String
        let details: String?
    }
}

// Simple error response for basic errors
struct SimpleErrorResponse: Decodable {
    let error: Bool
    let reason: String
}
