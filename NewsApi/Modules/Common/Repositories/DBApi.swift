//
//  DBApi.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 10.12.2020.
//

import Foundation
import FirebaseFirestore

class DBApi {
    
    static let shared = DBApi()
    
    private let db = Firestore.firestore()
    
    private let favoritesTable = "favorites"
    
    func addFavoritesNews(article: ArticleModel, _ completion: (() -> ())?) {
        guard let user = AppConfig.shared.currentUser else { return }
        
        var ref: DocumentReference? = nil
        ref = db.collection(favoritesTable).addDocument(data: [
            "uid": user.uid,
            "author": article.author ?? "",
            "title": article.title,
            "content": article.content ?? "",
            "description": article.description ?? "",
            "urlToImage": article.urlToImage ?? "",
            "publishedAt": article.publishedAt ?? "",
            "url": article.url ?? "",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
            completion?()
        }
    }
    
    func getFavorite(_ completion: (([ArticleModel]) -> ())?) {
        guard let user = AppConfig.shared.currentUser else { return }
        
        let ref = Firestore.firestore().collection(favoritesTable)
        
        ref.whereField("uid", isEqualTo: user.uid)
            .getDocuments(completion: {(querySnapshot, err) in
                
                if err == nil,
                   let querySnapshot = querySnapshot,
                   querySnapshot.documents.count != 0 {
                    
                    completion?(querySnapshot.documents.map({ doc in
                        return ArticleModel(
                            author: doc["author"] as? String ?? "",
                            title: doc["title"] as? String ?? "",
                            description: doc["description"] as? String ?? "",
                            url: doc["url"] as? String ?? "",
                            urlToImage: doc["urlToImage"] as? String ?? "",
                            publishedAt: doc["publishedAt"] as? String ?? "",
                            content: doc["content"] as? String ?? "")
                    }))
                } else {
                    completion?([])
                }
            })
    }
    
    func findFavoriteByUrl(url: String, _ completion: ((Bool) -> ())?) {
        guard let user = AppConfig.shared.currentUser else { return }
        
        let ref = Firestore.firestore().collection(favoritesTable)
        
        ref.whereField("uid", isEqualTo: user.uid)
            .whereField("url", isEqualTo: url)
            .getDocuments(completion: {(querySnapshot, err) in
                completion?(err == nil && querySnapshot?.documents.count != 0)
            })
    }
    
    func removeFavoriteByUrl(url: String, _ completion: (() -> ())?) {
        guard let user = AppConfig.shared.currentUser else { return }
        
        let ref = Firestore.firestore().collection(favoritesTable)
        
        ref.whereField("uid", isEqualTo: user.uid)
            .whereField("url", isEqualTo: url)
            .getDocuments(completion: { (querySnapshot, err) in
                
                if err == nil,
                   let querySnapshot = querySnapshot,
                   querySnapshot.documents.count != 0,
                   let document = querySnapshot.documents.first {
                    
                    document.reference.delete()
                    
                    completion?()
                }
            })
    }
}
