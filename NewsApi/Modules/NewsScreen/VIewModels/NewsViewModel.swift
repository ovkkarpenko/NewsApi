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
    private var articles: [ArticleModel] = []
    
    var items = PublishSubject<[SectionModel<String, ArticleModel>]>()
    
    func fetchItems(_ completion: (() -> ())? = nil) {
        ServerApi.shared.getTopHeadlines(page: page) { [weak self] news in
            guard let self = self else { return }
            
            self.articles.append(contentsOf: news.articles)
            self.items.onNext([SectionModel(model: "", items: self.articles)])
            completion?()
        }
    }
    
    func nextPage(_ completion: (() -> ())? = nil) {
        page += 1
        fetchItems(completion)
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
}
