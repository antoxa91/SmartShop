//
//  ShoppingListViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import UIKit
import OSLog

final class ShoppingListViewController: UIViewController {
    // MARK: Properties
    private let shoppingListTableView: ShoppingListTableView
    private var cartItems: [CartItem]
    
    // MARK: Init
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
        self.shoppingListTableView = ShoppingListTableView(cartItems: cartItems)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func loadView() {
        view = shoppingListTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        view.backgroundColor = AppColorEnum.lightWhite.color
        title = "Shopping List"
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteShoppingList))
        navigationItem.setRightBarButtonItems([deleteButton, shareButton], animated: true)
    }
    
    // MARK: Actions
    @objc private func shareShoppingList() {
        let totalCost = calculateTotalCost()
        let shoppingListText = generateShoppingListText()
        let finalText = "My Shopping List.\n\(shoppingListText)\n\nTotal Cost: \(totalCost) $"
        
        let activityViewController = UIActivityViewController(activityItems: [finalText], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc private func deleteShoppingList() {
        let alertController = UIAlertController(title: "Clean the Shopping List?", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Clean", style: .destructive) { [weak self] _ in
            self?.cartItems.removeAll()
            self?.shoppingListTableView.clearCartItems()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    
    // MARK: Helpers
    private func calculateTotalCost() -> Double {
        return cartItems.reduce(0) { $0 + (Double($1.product.price) * Double($1.quantity)) }
    }
    
    private func generateShoppingListText() -> String {
        return cartItems.map { cartItem in
            """
            Title: \(cartItem.product.title)
            Quantity: \(cartItem.quantity)
            Price: \(Double(cartItem.product.price) * Double(cartItem.quantity)) $
            """
        }.joined(separator: "\n\n")
    }
}
