//
//  NewsViewModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import RxSwift
import RxDataSources

class NewsViewModel {
    
    private var page = 1
    
    var isEndedPages = false
    var articles: [ArticleModel] = []
    var items = PublishSubject<[SectionModel<String, ArticleModel>]>()
    
    func fetchData(_ completion: (() -> ())? = nil) {
        if AppConfig.shared.isQueryChanged {
            AppConfig.shared.isQueryChanged = false
            isEndedPages = false
            page = 1
            articles.removeAll()
        }
        
        ServerApi.shared.getTopHeadlines(page: page) { [weak self] news in
            guard let self = self else { return }
            
            guard let news = news else {
                self.sortItems()
                completion?()
                return
            }
            
            if news.articles.count == 0 {
                self.isEndedPages = true
                completion?()
                return
            }
            
            self.addNewItems(news.articles)
            self.sortItems()
            completion?()
        }
    }
    
    func nextPage(_ completion: (() -> ())? = nil) {
        page += 1
        fetchData(completion)
    }
    
    func dataSource(cellIdentifier: String) -> RxTableViewSectionedReloadDataSource<SectionModel<String, ArticleModel>> {
        
        return RxTableViewSectionedReloadDataSource<SectionModel<String, ArticleModel>>(
            configureCell: { (_, tv, indexPath, item) in
                
                let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewsTableViewCell
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.authorLabel.text = item.author
                cell.sourceLabel.text = item.source.name
                
                if let url = item.urlToImage {
                    cell.logoImageView.imageFromUrl(url)
                }
                
                if item.author == nil {
                    cell.authorLabel.isHidden = true
                    cell.iconImageView.isHidden = true
                }
                
                return cell
            })
    }
    
    private func addNewItems(_ articles: [ArticleModel]) {
        articles.forEach { item in
            if !self.articles.contains(where: { $0.title == item.title }) {
                self.articles.append(item)
            }
        }
    }
    
    private func sortItems() {
        self.articles = self.articles.sorted(by: self.sortedArticles)
        self.items.onNext([SectionModel(model: "", items: self.articles)])
    }
    
    private func sortedArticles(item1: ArticleModel, item2: ArticleModel) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let stringDate1 = item1.publishedAt,
           let stringDate2 = item2.publishedAt,
           let date1 = dateFormatter.date(from: stringDate1),
           let date2 = dateFormatter.date(from: stringDate2) {
            
            return AppConfig.shared.sortedByDesc
                ? date1 > date2
                : date2 > date1
        }
        
        return false
    }
}
