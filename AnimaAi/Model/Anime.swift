import Foundation


struct Animes: Codable {
    let data: [Anime]
}



struct Anime: Codable {
    let identifier = UUID()
    let attributes: Attributes
    
    private enum CodingKeys: String, CodingKey {
        case attributes
    }
}

extension Anime: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct Attributes: Codable {
    let synopsis, description: String?
    let titles: Titles?
    let canonicalTitle: String?
    let abbreviatedTitles: [String?]
    let status: String?
    let posterImage: PosterImage?
    let episodeCount, episodeLength: Int?
    let totalLength: Int?
    let youtubeVideoId: String?
    let showType: String?
}


struct PosterImage: Codable {
    let tiny, large, small, medium: String
    let original: String
}

struct Titles: Codable {
    let en: String?
    let enJp, jaJp: String?
    let enUs: String?

    enum CodingKeys: String, CodingKey {
        case en
        case enJp = "en_jp"
        case jaJp = "ja_jp"
        case enUs = "en_us"
    }
}
