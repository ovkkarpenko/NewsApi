//
//  NewsViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import RxSwift
import NVActivityIndicatorView
import Firebase
import GoogleSignIn

class NewsViewController: UIViewController {
    
    private lazy var filteringButton: UIButton = {
        let button = PrimaryButton(title: "Filtering")
        button.addTarget(self, action: #selector(filteringButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = PrimaryButton(title: "Favorite")
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var singOutButton: UIButton = {
        let button = PrimaryButton(title: "Sing out")
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(singOutButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loaderView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .pacman, color: FontColorHelper.second.color())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        setupUI()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        viewModel.fetchData(stopLoading)
    }
    
    private let bag = DisposeBag()
    private let viewModel = NewsViewModel()
    
    private let padding: CGFloat = 20
    private let cellIdentifier = "NewsCell"
    
    private lazy var loaderViewHeightConstraint = loaderView.heightAnchor.constraint(equalToConstant: 0)
    
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loaderView)
        view.addSubview(filteringButton)
        view.addSubview(favoriteButton)
        view.addSubview(singOutButton)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: loaderView.topAnchor),
            
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loaderView.bottomAnchor.constraint(equalTo: filteringButton.topAnchor, constant: -padding),
            loaderViewHeightConstraint,
            
            filteringButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            filteringButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            filteringButton.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -10),
            
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            favoriteButton.bottomAnchor.constraint(equalTo: singOutButton.topAnchor, constant: -10),
            
            singOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            singOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            singOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2)
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
    
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        
        searchBar.searchTextField.rx
            .controlEvent(.editingChanged)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                
                AppConfig.shared.isQueryChanged = true
                AppConfig.shared.filteringQuery = text
                
                self.startLoading()
                self.viewModel.fetchData(self.stopLoading)
            }).disposed(by: bag)
        
        self.navigationItem.titleView = searchBar
    }
    
    func startLoading() {
        tableView.isScrollEnabled = false
        loaderViewHeightConstraint.constant = 40
        loaderView.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isScrollEnabled = true
            self?.loaderViewHeightConstraint.constant = 0
            self?.loaderView.stopAnimating()
        }
    }
    
    @objc private func filteringButtonPressed() {
        let vc = FilteringViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func favoriteButtonPressed() {
        let vc = FavoriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func singOutButtonPressed() {
        AppConfig.shared.idToken = ""
        AppConfig.shared.accessToken = ""
        AppConfig.shared.currentUser = nil
        
        try? Auth.auth().signOut()
        self.navigationController?.dismiss(animated: true)
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 150 {
            
            if !viewModel.isEndedPages && viewModel.articles.count >= 20 {
                startLoading()
                viewModel.nextPage(stopLoading)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
