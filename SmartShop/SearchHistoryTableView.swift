//
//  SearchHistoryTableView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit

final class SearchHistoryTableView: UITableView {
    private var searchHistory: [String] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 30
        backgroundColor = AppColorEnum.tfBg.color
    }
    
    func updateSearchHistory(_ history: [String]) {
        searchHistory = history
        reloadData()
        isHidden = history.isEmpty
    }
}

// MARK: UITableViewDataSource
extension SearchHistoryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row]
        cell.backgroundColor = AppColorEnum.tfBg.color
        return cell
    }
}
