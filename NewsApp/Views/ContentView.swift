//
//  ContentView.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showSavedArticles = false

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article, viewModel: viewModel)) {
                    ArticleRow(article: article)
                }
            }
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSavedArticles = true
                    }) {
                        Image(systemName: "bookmark.fill")
                    }
                }
            }
            .sheet(isPresented: $showSavedArticles) {
                SavedArticlesView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
