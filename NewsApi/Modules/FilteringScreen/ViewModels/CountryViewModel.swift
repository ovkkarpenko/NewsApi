//
//  CountryViewModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import RxSwift
import RxDataSources

class CountryViewModel {
    
    let countries = ["pl": "Poland", "eg": "Egypt", "rs": "Russian", "us": "United States"]
    let items = Observable<[SectionModel<String, String>]>.of([SectionModel<String, String>(model: "", items: ["pl", "eg", "rs", "us"])])
    
    func dataSource(cellIdentifier: String) -> RxTableViewSectionedReloadDataSource<SectionModel<String, String>> {
        
        return RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { (_, tv, indexPath, item) in
                
                let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier)!
                cell.textLabel?.text = self.countries[item]
                return cell
            })
    }
}
