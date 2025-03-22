//
//  ArticleRow.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    var onReadMore: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100) 
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title ?? "No Title")
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.articleDescription ?? "No Description")
                    .font(.subheadline)
                    .lineLimit(3)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        onReadMore()
                    }) {
                        Text("Read More...")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle()) // Prevent button from triggering cell tap
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Add a border
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.vertical, 5) //cells space (top and bottom)
        .contentShape(Rectangle()) // cell tappable
        .onTapGesture {
            
        }
    }
}
