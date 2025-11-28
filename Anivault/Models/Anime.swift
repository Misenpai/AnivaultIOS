import Foundation

struct Anime: Identifiable, Codable, Equatable {
    let malId: Int
    let title: String
    let images: AnimeImages
    let score: Double?
    let synopsis: String?
    let year: Int?

    var id: Int { malId }

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title
        case images
        case score
        case synopsis
        case year
    }
}

struct AnimeImages: Codable, Equatable {
    let jpg: AnimeImageUrls
    let webp: AnimeImageUrls
}

struct AnimeImageUrls: Codable, Equatable {
    let imageUrl: String
    let smallImageUrl: String?
    let largeImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
}

struct SeasonAnimeResponse: Codable {
    let data: [Anime]
    let pagination: Pagination
}

struct Pagination: Codable {
    let lastVisiblePage: Int
    let hasNextPage: Bool

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
    }
}
