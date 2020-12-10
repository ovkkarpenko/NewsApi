//
//  ServerConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

let baseUrl = "http://newsapi.org"
let baseApiUrl = "\(baseUrl)/v2"
let apiKey = "d2b14a7bfa814b67a26dbc7cc6947b9c"

enum ApiMethods {
    case topHeadlines
    
    func method() -> String {
        switch self {
        case .topHeadlines:
            return "top-headlines"
        }
    }
}
