//
//  NewsTableViewCell.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = FontColorHelper.primary.color()
        label.font = .boldSystemFont(ofSize: FontSizeHelper.title.size())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = FontColorHelper.primary.color()
        label.font = .systemFont(ofSize: FontSizeHelper.second.size())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = FontColorHelper.second.color()
        label.font = .systemFont(ofSize: FontSizeHelper.title.size())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: "dot.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = FontColorHelper.second.color()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = FontColorHelper.second.color()
        label.font = .systemFont(ofSize: FontSizeHelper.title.size())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, iconImageView, sourceLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = padding/2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private let padding: CGFloat = 20
    
    func setupLayout() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            logoImageView.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -padding),
            logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            horizontalStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding/2),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
