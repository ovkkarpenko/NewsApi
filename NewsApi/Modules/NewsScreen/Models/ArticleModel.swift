//
//  ArticleModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Foundation

struct ArticleModel {
    
    var source: ArticleSourceModel
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init(author: String?, title: String, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = ArticleSourceModel(id: "", name: "")
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

struct ArticleSourceModel {
    
    var id: String?
    var name: String
}

extension ArticleModel: Codable {
    
}


extension ArticleSourceModel: Codable {
    
}
