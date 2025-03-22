//
//  SavedArticlesView.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import SwiftUI

struct SavedArticlesView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var selectedArticle: Article? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.savedArticles) { article in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 10) {
                            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .clipped() 
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }

                            // Article Details on the right
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.title ?? "No Title")
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(article.articleDescription ?? "No Description")
                                    .font(.subheadline)
                                    .lineLimit(3) 
                            }

                            Spacer()

                            Button(action: {
                                viewModel.deleteArticle(article)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(8)
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevent button from triggering cell tap
                        }

                        HStack {
                            Spacer()
                            Button(action: {
                                selectedArticle = article
                            }) {
                                Text("Read More...")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevent button from triggering cell tap
                        }
                    }
                    .padding() // Add padding inside the cell
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Add a border
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.vertical, 5) // Add space between cells (top and bottom)
                    .contentShape(Rectangle()) //  cell tappable
                    .onTapGesture {
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle()) // Use a plain list style
            .navigationTitle("Saved Articles")
            .navigationDestination(isPresented: Binding(
                get: { selectedArticle != nil },
                set: { _ in selectedArticle = nil }
            )) {
                if let selectedArticle = selectedArticle {
                    ArticleDetailView(article: selectedArticle, viewModel: viewModel)
                }
            }
        }
    }
}
