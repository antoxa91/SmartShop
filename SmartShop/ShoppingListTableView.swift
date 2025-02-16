//
//  ShoppingListTableView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import UIKit

protocol ShoppingListTableViewDelegate: AnyObject {
    func didSelectShoppingItem(_ item: String)
}

final class ShoppingListTableView: UITableView {
    weak var shoppingListTableViewDelegate: ShoppingListTableViewDelegate?
    private var cartItem: [CartItem] = []
    
    // MARK: Init
    init(cartItem: [CartItem]) {
        self.cartItem = cartItem
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        dataSource = self
        delegate = self
        register(ShoppingListTableViewCell.self,
                 forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        rowHeight = 150
        backgroundColor = AppColorEnum.lightWhite.color
        separatorStyle = .singleLine
        separatorColor = .lightGray
        bounces = false
    }
}

// MARK: - UITableViewDataSource
extension ShoppingListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell else {
            return UITableViewCell()
        }
        let cartItem = cartItem[indexPath.row]
        cell.configure(with: cartItem.product, quantity: cartItem.quantity)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ShoppingListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
}
