//
//  FavoriteViewModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 10.12.2020.
//

import Foundation
import RxSwift
import RxDataSources

class FavoriteViewModel {
    
    var items = PublishSubject<[SectionModel<String, ArticleModel>]>()
    
    func fetchData(_ completion: (() -> ())? = nil) {
        DBApi.shared.getFavorite { [weak self] news in
            self?.items.onNext([SectionModel(model: "", items: news)])
        }
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
