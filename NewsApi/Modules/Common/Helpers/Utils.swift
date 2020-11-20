//
//  Utils.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit

extension UIImageView {
    
    func imageFromUrl(_ string: String) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: string),
               let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
