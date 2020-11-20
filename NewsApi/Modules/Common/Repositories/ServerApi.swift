//
//  ServerApi.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Alamofire

class ServerApi {
    
    public static let shared = ServerApi()
    
    private init() { }
    
    func getTopHeadlines(page: Int, _ completion: @escaping (NewsModel) -> ()) {
        var params = "page=\(page)&country=us"
        
        if let country = filteringCountry.first?.key,
           let category = filteringCategory.first?.key {
            params = "country=\(country)&category=\(category)&page=\(page)&country=us"
        }
        
        if filteringQuery != "" {
            params += "&q=\(filteringQuery)"
        }
        
        let url = makeUrl(ApiMethods.topHeadlines.method(), params: params)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: NewsModel.self) { (response) in
                
                if let news = response.value {
                    completion(news)
                }
            }
    }
    
    private func makeUrl(_ method: String, params: String? = nil) -> String {
        
        return "\(baseApiUrl)/" +
            "\(method)/" +
            "?\(params ?? "")" +
            "&apiKey=\(apiKey)"
    }
}
