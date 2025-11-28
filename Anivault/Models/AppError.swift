import Foundation

enum AppError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
    case unauthorized
    case unknown
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Session expired. Please login again."
        case .unknown:
            return "An unknown error occurred."
        case .custom(let message):
            return message
        }
    }
}
