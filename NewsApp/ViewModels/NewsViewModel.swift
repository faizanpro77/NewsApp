//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import Foundation
import CoreData
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var savedArticles: [Article] = []
    @Published var selectedArticle: Article? = nil
    @Published var showDuplicateAlert = false

    private let apiKey = "f54af074b84244248512dc6b9490adb9"
    private let context = PersistenceController.shared.container.viewContext

    func fetchNews(completion: @escaping (Bool) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var currentDate = dateFormatter.string(from: Date())
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=\(apiKey)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid HTTP response")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles = decodedResponse.articles
                    print("Articles fetched successfully: \(self.articles)")
                    completion(true)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    func saveArticle(_ article: Article) {
        if fetchArticleEntity(with: article.id) == nil {
            let newArticle = ArticleEntity(context: context)
            newArticle.id = article.id
            newArticle.title = article.title
            newArticle.articleDescription = article.articleDescription
            newArticle.url = article.url
            newArticle.urlToImage = article.urlToImage
            newArticle.publishedAt = article.publishedAt

            do {
                try context.save()
                fetchSavedArticles()
            } catch {
                print("Failed to save article: \(error)")
            }
        } else {
            showDuplicateAlert = true
        }
    }

    func deleteArticle(_ article: Article) {
        if let articleEntity = fetchArticleEntity(with: article.id) {
            context.delete(articleEntity)
            do {
                try context.save()
                fetchSavedArticles()
            } catch {
                print("Failed to delete article: \(error)")
            }
        }
    }

    
    func fetchSavedArticles() {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let articleEntities = try context.fetch(request)
            savedArticles = articleEntities.map { Article(entity: $0) }
        } catch {
            print("Failed to fetch saved articles: \(error)")
        }
    }
    
    private func fetchArticleEntity(with id: UUID) -> ArticleEntity? {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
}
