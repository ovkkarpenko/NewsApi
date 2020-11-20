//
//  NewsViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import RxSwift

class NewsViewController: UIViewController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filteringButton: UIButton = {
        let button = PrimaryButton(title: "Filtering")
        
        button.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {
                let vc = FilteringViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: bag)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        setupLayout()
        setupTableView()
        setupSearchBar()
    }
    
    private let bag = DisposeBag()
    private let viewModel = NewsViewModel()
    
    private let padding: CGFloat = 20
    private let cellIdentifier = "NewsCell"
    
    func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(filteringButton)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: filteringButton.topAnchor, constant: -padding),
            
            filteringButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            filteringButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            filteringButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2)
        ])
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
                vc.urlString = article.url
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: bag)
        
        viewModel.fetchItems { [weak self] in
            self?.tableView.isScrollEnabled = true
        }
    }
    
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        
        searchBar.searchTextField.rx
            .controlEvent(.editingChanged)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                
                if text != "" {
                    filteringQuery = text
                    self.viewModel.fetchItems()
                }
            }).disposed(by: bag)
        
        self.navigationItem.titleView = searchBar
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 150 {
            
            scrollView.isScrollEnabled = false
            viewModel.nextPage {
                scrollView.isScrollEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
