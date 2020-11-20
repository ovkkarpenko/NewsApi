//
//  FilteringViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import RxSwift

class FilteringViewController: UIViewController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortedLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort from newest:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortedSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = sortedByDesc
        
        uiSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(uiSwitch.rx.isOn)
            .subscribe(onNext: { checked in
                
                sortedByDesc = checked
            }).disposed(by: bag)
        
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupTableView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if filteringCountry.first?.key == "all" && filteringCategory.first?.key == "all" {
            
            let alert = UIAlertController(
                title: "Error",
                message: "You need to select at least one search parameter.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.navigationController?.present(alert, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reloadData()
    }
    
    private let padding: CGFloat = 20
    private let cellIdentifier = "FilteringCell"
    
    private let bag = DisposeBag()
    private let viewModel = FilteringViewModel()
    
    func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(sortedLabel)
        view.addSubview(sortedSwitch)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: sortedSwitch.topAnchor, constant: padding),
            
            sortedLabel.trailingAnchor.constraint(equalTo: sortedSwitch.leadingAnchor, constant: -padding),
            sortedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2-6),
            
            sortedSwitch.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2),
            sortedSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70)
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
                
                if item == "Country" {
                    let vc = CountryViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if item == "Category" {
                    let vc = CategoryViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: bag)
    }
}
