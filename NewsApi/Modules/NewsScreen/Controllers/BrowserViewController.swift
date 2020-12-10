//
//  BrowserViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view = webView
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        checkIfFavoriteExists()
        
        if let urlString = article?.url ,
           let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    var isFavoriteButtonActive: Bool = false
    var article: ArticleModel?
    
    func setupLayout() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func checkIfFavoriteExists() {
        guard let article = article,
              let url = article.url else { return }
        
        DBApi.shared.findFavoriteByUrl(url: url) { [weak self] isExists in
            if isExists {
                self?.toggleFavoriteButton()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "heart"),
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(markFavorite))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    private func toggleFavoriteButton() {
        if isFavoriteButtonActive {
            isFavoriteButtonActive = false
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            isFavoriteButtonActive = true
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }
    
    @objc private func markFavorite() {
        guard let article = article,
              let url = article.url else { return }
        
        if isFavoriteButtonActive {
            DBApi.shared.removeFavoriteByUrl(url: url) { [weak self] in
                self?.toggleFavoriteButton()
            }
        } else {
            DBApi.shared.addFavoritesNews(article: article) { [weak self] in
                self?.toggleFavoriteButton()
            }
        }
    }
}
