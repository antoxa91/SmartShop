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
    var cartItems: [CartItem] { get }
    func addCartItem(_ item: CartItem)
    func removeCartItem(at index: Int)
    func clearCartItems()
    func calculateTotalCost() -> Double
    func generateShoppingListText() -> String
}

final class ShoppingCartManager: ShoppingCartManagerProtocol {
    private(set) var cartItems: [CartItem] = []
    static let shared = ShoppingCartManager()
    private let fileURL: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("shoppingCartItems.json")
        loadCartItems()
    }
    
    func addCartItem(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.product.id == item.product.id }) {
            cartItems[index].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
        saveCartItems()
    }
    
    func removeCartItem(at index: Int) {
        cartItems.remove(at: index)
        saveCartItems()
    }
    
    func clearCartItems() {
        cartItems.removeAll()
        saveCartItems()
    }
    
    func calculateTotalCost() -> Double {
        return cartItems.reduce(0) { $0 + (Double($1.product.price) * Double($1.quantity)) }
    }
    
    func generateShoppingListText() -> String {
        return cartItems.map { "\($0.product.title) - \($0.quantity) pcs" }.joined(separator: "\n")
    }
    
    private func saveCartItems() {
        do {
            let data = try JSONEncoder().encode(cartItems)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save cart items: \(error)")
        }
    }
    
    private func loadCartItems() {
        do {
            let data = try Data(contentsOf: fileURL)
            cartItems = try JSONDecoder().decode([CartItem].self, from: data)
        } catch {
            print("Failed to load cart items: \(error)")
        }
    }
}
