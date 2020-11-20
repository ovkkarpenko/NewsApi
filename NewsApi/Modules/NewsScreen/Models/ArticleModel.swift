//
//  ArticleModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Foundation

struct ArticleModel: Codable {
    
    var source: ArticleSourceModel
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct ArticleSourceModel: Codable {
    
    var id: String?
    var name: String
}
