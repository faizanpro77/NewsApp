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
    @State private var selectedArticle: Article? = nil
    @State private var isLoading = false  

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    if viewModel.articles.isEmpty && !isLoading {
                        Text("No articles available. Please check your internet connection.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.articles) { article in
                                ArticleRow(article: article) {
                        // Set the selected article when "Read More..." is clicked
                                    selectedArticle = article
                                }
                                // Remove default list row padding
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                        .navigationTitle("News")
                        .navigationDestination(isPresented: Binding(
                            get: { selectedArticle != nil },
                            set: { _ in selectedArticle = nil }
                        )) {
                            if let selectedArticle = selectedArticle {
                                ArticleDetailView(article: selectedArticle, viewModel: viewModel)
                            }
                        }
                    }

                    // Bottom Bar
                    HStack {
                        Button(action: {
                           
                        }) {
                            Text("Home")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)

                        Button(action: {
                            viewModel.fetchSavedArticles()
                            // Navigate to SavedArticlesView
                            showSavedArticles = true
                        }) {
                            Text("Saved")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(.systemBackground))
                    .shadow(radius: 2)
                }

                // Loader
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5) 
                        .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(10)
                }
            }
            .navigationDestination(isPresented: $showSavedArticles) {
                SavedArticlesView(viewModel: viewModel)
            }
            .onAppear {
                isLoading = true // Show loader 
                viewModel.fetchNews { success in
                    isLoading = false // Hide loader
                    if !success {
                        isLoading = true
                        print("Failed to fetch news articles")
                    }
                }
            }
        }
    }
}
