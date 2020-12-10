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
    
    func getTopHeadlines(page: Int, _ completion: @escaping (NewsModel?) -> ()) {
        var params = "page=\(page)"
        
        if let country = AppConfig.shared.filteringCountry.first?.key,
           country != "all" {
            params += "&country=\(country)"
        }
        
        if let category = AppConfig.shared.filteringCategory.first?.key,
           category != "all" {
            params += "&category=\(category)"
        }
        
        if AppConfig.shared.filteringQuery != "" {
            params += "&q=\(AppConfig.shared.filteringQuery)"
        }
        
        let url = makeUrl(ApiMethods.topHeadlines.method(), params: params)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: NewsModel.self) { (response) in
                
                if let news = response.value {
                    completion(news)
                } else {
                    completion(nil)
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
