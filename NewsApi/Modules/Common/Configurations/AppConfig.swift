//
//  AppConfig.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import Firebase
import Foundation

class AppConfig {
    static let shared = AppConfig()
    
    private let idTokenKey = "idToken"
    private let accessTokenKey = "accessToken"
    private let countryKey = "country"
    private let categoryKey = "category"
    private let sortedByDescKey = "sortedByDesc"
    
    var filteringQuery = ""
    var isQueryChanged = false
    
    var currentUser: User?
    
    var idToken: String? {
        get {
            UserDefaults.standard.string(forKey: idTokenKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: idTokenKey)
        }
    }
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: accessTokenKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: accessTokenKey)
        }
    }
    
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
}
