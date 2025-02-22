//
//  ShoppingListTableView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import UIKit

protocol ShoppingListTableViewDelegate: AnyObject {
    func didSelectShoppingItem(_ item: CartItem)
}

final class ShoppingListTableView: UITableView {
    weak var shoppingListTableViewDelegate: ShoppingListTableViewDelegate?
    var cartItems: [CartItem] = []
    
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
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
    }
    
    // MARK: Action
    func clearCartItems() {
        UIView.animate(withDuration: 0.5, animations: {
            for cell in self.visibleCells {
                cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.alpha = 0
            }
        }, completion: { [weak self] _ in
            self?.cartItems.removeAll()
            self?.reloadData()
        })
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = cartItems.remove(at: sourceIndexPath.row)
        cartItems.insert(movedItem, at: destinationIndexPath.row)
        ShoppingCartManager.shared.updateCartItems(cartItems)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension ShoppingListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        let selectedItem = cartItems[indexPath.row]
        shoppingListTableViewDelegate?.didSelectShoppingItem(selectedItem)
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
                    ShoppingCartManager.shared.removeCartItem(at: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
