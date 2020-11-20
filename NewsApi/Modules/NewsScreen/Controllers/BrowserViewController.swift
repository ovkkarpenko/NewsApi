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
        
        if let urlString = urlString ,
           let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    var urlString: String?
    
    func setupLayout() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
