//
//  AppConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Foundation


private let countryKey = "country"
private let categoryKey = "category"
private let sortedByDescKey = "sortedByDesc"

var filteringQuery = ""

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

var sortedByDesc: Bool {
    get {
        UserDefaults.standard.bool(forKey: sortedByDescKey)
    } set {
        UserDefaults.standard.setValue(newValue, forKey: sortedByDescKey)
    }
}
