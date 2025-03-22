//
//  NewsResponse.swift
//  NewsApp
//
//  Created by shaikh faizan on 22/03/25.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [Article]
}
