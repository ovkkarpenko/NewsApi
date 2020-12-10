//
//  FavoriteViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 10.12.2020.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class FavoriteViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        setupUI()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchData()
    }
    
    private let bag = DisposeBag()
    private let viewModel = FavoriteViewModel()
    
    private let padding: CGFloat = 20
    private let cellIdentifier = "FavoriteNewsCell"
    
    func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.backgroundColor = .white
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource(cellIdentifier: cellIdentifier)))
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(ArticleModel.self)
            .subscribe(onNext: { [weak self] article in
                
                let vc = BrowserViewController()
                vc.article = article
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: bag)
    }
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
