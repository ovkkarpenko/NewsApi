//
//  ConstantsHelper.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit

enum AnimateDurationHelper {
    case base
    
    func duration() -> Double {
        switch self {
        case .base:
            return 0.2
        }
    }
}

enum FontColorHelper {
    case primary
    case second
    case primaryButton
    
    func color() -> UIColor {
        switch self {
        case .primary:
            return UIColor.black
        case .second:
            return UIColor.gray
        case .primaryButton:
            return UIColor.white
        }
    }
}

enum FontSizeHelper {
    case primary
    case second
    case title
    
    func size() -> CGFloat {
        switch self {
        case .primary:
            return 16
        case .second:
            return 14
        case .title:
            return 12
        }
    }
}
