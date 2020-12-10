//
//  FilteringViewModel.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import RxSwift
import RxDataSources
import Foundation

class FilteringViewModel {
    
    let menu = ["Country", "Category"]
    let items = PublishSubject<[SectionModel<String, String>]>()
    
    init() {
        reloadData()
    }
    
    func reloadData() {
        items.onNext([SectionModel<String, String>(model: "", items: menu)])
    }
    
    func dataSource(cellIdentifier: String) -> RxTableViewSectionedReloadDataSource<SectionModel<String, String>> {
        
        return RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { (_, tv, indexPath, item) in
                
                let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier)!
                cell.subviews.first { $0 is UILabel }?.removeFromSuperview()
                cell.textLabel?.text = item
                cell.accessoryType = .disclosureIndicator
                
                let label = UILabel()
                label.text = item == "Country" ? AppConfig.shared.filteringCountry.first?.value as! String : AppConfig.shared.filteringCategory.first?.value as! String
                label.font = .systemFont(ofSize: FontSizeHelper.title.size())
                label.textColor = FontColorHelper.second.color()
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15),
                    label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -40)
                ])
                
                return cell
            })
    }
}
