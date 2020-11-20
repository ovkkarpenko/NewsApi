//
//  NewsModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Foundation

struct NewsModel: Decodable {
    
    var status: String
    var totalResults: Int
    var articles: [ArticleModel]
}
