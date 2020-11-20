//
//  ServerConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

let baseUrl = "http://newsapi.org"
let baseApiUrl = "http://newsapi.org/v2"
let apiKey = "64468ca542374dce82a5611ecbf3c7d0"

enum ApiMethods {
    case topHeadlines
    
    func method() -> String {
        switch self {
        case .topHeadlines:
            return "top-headlines"
        }
    }
}
