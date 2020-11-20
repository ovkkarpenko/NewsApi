//
//  AppConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Foundation


private let countryKey = "country"
private let categoryKey = "category"

var filteringQuery: String = ""

var filteringCountry: [String : Any] {
    get {
        UserDefaults.standard.dictionary(forKey: countryKey) ?? ["pl" : "Poland"]
    } set {
        UserDefaults.standard.setValue(newValue, forKey: countryKey)
    }
}

var filteringCategory: [String : Any] {
    get {
        UserDefaults.standard.dictionary(forKey: categoryKey) ?? ["business" : "Business"]
    } set {
        UserDefaults.standard.setValue(newValue, forKey: categoryKey)
    }
}
