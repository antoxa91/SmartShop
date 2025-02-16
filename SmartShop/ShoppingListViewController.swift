//
//  ShoppingListViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import UIKit

final class ShoppingListViewController: UIViewController {
    private let shoppingListTableView: ShoppingListTableView
    private var cartItems: [CartItem] = []
    
    // MARK: Init
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
        self.shoppingListTableView = ShoppingListTableView(cartItem: cartItems)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func loadView() {
        super.loadView()
        view = shoppingListTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = AppColorEnum.lightWhite.color
        title = "Shopping List"
    }
}
