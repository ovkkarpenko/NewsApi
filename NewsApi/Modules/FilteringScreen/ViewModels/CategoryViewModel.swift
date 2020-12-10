//
//  CategoryViewModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import RxSwift
import RxDataSources

class CategoryViewModel {
    
    let categories = ["business": "Business", "entertainment": "Entertainment", "general": "General", "health": "Health", "science": "Science", "sports": "Sports", "technology": "Technology"]
    let items = Observable<[SectionModel<String, String>]>.of([SectionModel<String, String>(model: "", items: ["business", "entertainment", "general", "health", "science", "sports", "technology"])])
    
    func dataSource(cellIdentifier: String) -> RxTableViewSectionedReloadDataSource<SectionModel<String, String>> {
        
        return RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { (_, tv, indexPath, item) in
                
                let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier)!
                cell.textLabel?.text = self.categories[item]
                return cell
            })
    }
}
