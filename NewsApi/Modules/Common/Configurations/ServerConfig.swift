//
//  ServerConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

let baseUrl = "http://newsapi.org"
let baseApiUrl = "http://newsapi.org/v2"
let apiKey = "634963ea644246bfbaa404306e4a0af2"

enum ApiMethods {
    case topHeadlines
    
    func method() -> String {
        switch self {
        case .topHeadlines:
            return "top-headlines"
        }
    }
}
