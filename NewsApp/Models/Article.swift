//
//  Article.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import Foundation

struct Article: Identifiable, Decodable, Equatable {
    let id: UUID
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
        case url
        case urlToImage
        case publishedAt
    }

    // Memberwise initializer
    init(
        id: UUID = UUID(),
        title: String?,
        articleDescription: String?,
        url: String?,
        urlToImage: String?,
        publishedAt: String?
    ) {
        self.id = id
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }

    // Custom initializer for JSON decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Initialize id here
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.articleDescription = try container.decodeIfPresent(String.self, forKey: .articleDescription)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
    }

    // Custom initializer for mapping ArticleEntity to Article
    init(entity: ArticleEntity) {
        self.id = entity.id ?? UUID() // Initialize id here
        self.title = entity.title
        self.articleDescription = entity.articleDescription
        self.url = entity.url
        self.urlToImage = entity.urlToImage
        self.publishedAt = entity.publishedAt
    }

    // Implement Equatable conformance
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id // Compare articles based on their unique ID
    }
}

// MARK: - Mock Article for Initialization
extension Article {
    static let mock = Article(
        title: "Mock Article",
        articleDescription: "This is a mock article for initialization purposes.",
        url: "https://example.com",
        urlToImage: nil,
        publishedAt: "2025-03-22T00:00:00Z"
    )
}
