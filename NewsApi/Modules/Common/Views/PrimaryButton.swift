//
//  PrimaryButton.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit

class PrimaryButton: UIButton {
    
    convenience init(title: String) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 15
        titleLabel?.font = .systemFont(ofSize: FontSizeHelper.primary.size())
        setTitleColor(FontColorHelper.primaryButton.color(), for: .normal)
        backgroundColor = .gray
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
