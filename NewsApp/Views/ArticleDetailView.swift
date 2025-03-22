//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//


import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @ObservedObject var viewModel: NewsViewModel
    @State private var showSavedArticles = false 
    @State private var webViewURL: URL?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let webViewURL = webViewURL {
                WebView(url: webViewURL)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button(action: {
                viewModel.saveArticle(article)
                if !viewModel.showDuplicateAlert {
                    showSavedArticles = true  // Navigate to SavedArticlesView
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Article/Blog")
        .navigationDestination(isPresented: $showSavedArticles) {
            SavedArticlesView(viewModel: viewModel)
        }
        .alert("Article Already Saved", isPresented: $viewModel.showDuplicateAlert) {
            Button("OK", role: .cancel) {
                // Navigate to SavedArticlesView
                showSavedArticles = true
            }
        } message: {
            Text("This article is already saved in your list.")
        }
        .onAppear {
            webViewURL = URL(string: article.url ?? "NA")
            print("Article URL: \(article.url ?? "No URL available")")
        }
        .onChange(of: article) { newArticle in
            webViewURL = URL(string: newArticle.url ?? "NA")
        }
    }
}
