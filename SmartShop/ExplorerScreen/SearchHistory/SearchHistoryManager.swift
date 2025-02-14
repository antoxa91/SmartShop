//
//  SearchHistoryManager.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import Foundation

final class SearchHistoryManager {
    static let shared = SearchHistoryManager()
    private let userDefaults = UserDefaults.standard
    private let historyKey = "searchHistory"
    private let maxHistoryCount = 5
    
    func addSearchQuery(_ query: String) {
        var history = getSearchHistory()
        if let index = history.firstIndex(of: query) {
            history.remove(at: index)
        }
        history.insert(query, at: 0)
        if history.count > maxHistoryCount {
            history.removeLast()
        }
        userDefaults.set(history, forKey: historyKey)
    }
    
    func getSearchHistory() -> [String] {
        return userDefaults.stringArray(forKey: historyKey) ?? []
    }
}
