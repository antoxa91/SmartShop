//
//  ShoppingCartManager.swift
//  SmartShop
//
//  Created by Антон Стафеев on 17.02.2025.
//

import Foundation

protocol ShoppingListViewControllerDelegate: AnyObject {
    func shoppingListViewControllerDidToggleEditing(_ viewController: ShoppingListViewController, isEditing: Bool)
    func shoppingListViewControllerDidRequestDeleteAll(_ viewController: ShoppingListViewController)
    func shoppingListViewControllerDidRequestShare(_ viewController: ShoppingListViewController)
}

protocol ShoppingCartManagerProtocol {
    var cartItems: [CartItem] { get set }
    func calculateTotalCost() -> Double
    func generateShoppingListText() -> String
    func clearCartItems()
}

final class ShoppingCartManager: ShoppingCartManagerProtocol {
    var cartItems: [CartItem]
    
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
    }
    
    func calculateTotalCost() -> Double {
        return cartItems.reduce(0) { $0 + (Double($1.product.price) * Double($1.quantity)) }
    }
    
    func generateShoppingListText() -> String {
        return cartItems.map { cartItem in
            """
            Title: \(cartItem.product.title)
            Quantity: \(cartItem.quantity)
            Price: \(Double(cartItem.product.price) * Double(cartItem.quantity)) $
            """
        }.joined(separator: "\n\n")
    }
    
    func clearCartItems() {
        cartItems.removeAll()
    }
}
