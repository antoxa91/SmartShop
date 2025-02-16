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
    private var cartItems: [CartItem] = []
    
    // MARK: Init
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
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
        cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell else {
            return UITableViewCell()
        }
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem.product, quantity: cartItem.quantity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate
extension ShoppingListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.5, animations: {
                    cell.transform = .init(scaleX: 0.1, y: 0.1)
                    cell.alpha = 0
                    cell.layer.zPosition = -1
                }, completion: { _ in
                    self.cartItems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                })
            } else {
                self.cartItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
        }
        
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
