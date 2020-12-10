//
//  CountryViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import RxSwift
import RxDataSources

class CountryViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupTableView()
    }
    
    private let padding: CGFloat = 20
    private let cellIdentifier = "CountryCell"
    
    private let bag = DisposeBag()
    private let viewModel = CountryViewModel()
    
    func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource(cellIdentifier: cellIdentifier)))
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { item in
                
                AppConfig.shared.isQueryChanged =  true
                AppConfig.shared.filteringCountry = [item : self.viewModel.countries[item] ?? ""]
                
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: bag)
    }
}
