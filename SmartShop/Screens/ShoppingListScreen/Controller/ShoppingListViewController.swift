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
    weak var delegate: ShoppingListViewControllerDelegate?
    private var shoppingCartManager: ShoppingCartManagerProtocol

    lazy var shoppingListTableView = ShoppingListTableView(cartItems: shoppingCartManager.cartItems)
    private lazy var deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "trash")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.title = "Delete All"
        config.baseBackgroundColor = AppColorEnum.pink.color
        config.baseForegroundColor = AppColorEnum.red.color
        button.configuration = config
        button.addTarget(self, action: #selector(deleteShoppingList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    init(shoppingCartManager: ShoppingCartManagerProtocol) {
         self.shoppingCartManager = shoppingCartManager
         super.init(nibName: nil, bundle: nil)
     }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingListTableView.cartItems = shoppingCartManager.cartItems
        shoppingListTableView.reloadData()
    }
    
    // MARK: Setup
    private func setup() {
        view.backgroundColor = AppColorEnum.lightWhite.color
        title = "Shopping List"
        view.addSubviews(shoppingListTableView, deleteAllButton)
    }
    
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.setRightBarButtonItems([shareButton, editButton], animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            shoppingListTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            shoppingListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            shoppingListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deleteAllButton.heightAnchor.constraint(equalToConstant: 50),
            deleteAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAllButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            deleteAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Actions
    @objc private func shareShoppingList() {
        let totalCost = shoppingCartManager.calculateTotalCost()
        let shoppingListText = shoppingCartManager.generateShoppingListText()
        let finalText = "My Shopping List.\n\(shoppingListText)\n\nTotal Cost: \(totalCost) $"
        
        let activityViewController = UIActivityViewController(activityItems: [finalText], applicationActivities: nil)
        present(activityViewController, animated: true)
        delegate?.shoppingListViewControllerDidRequestShare(self)
    }
    
    @objc private func toggleEditing() {
        shoppingListTableView.isEditing = !shoppingListTableView.isEditing
        navigationItem.rightBarButtonItems?.last?.title = shoppingListTableView.isEditing ? "Done" : "Edit"
        delegate?.shoppingListViewControllerDidToggleEditing(self, isEditing: shoppingListTableView.isEditing)
    }
    
    @objc private func deleteShoppingList() {
        let alertController = UIAlertController(title: "Clean the Shopping List?", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Clean", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.shoppingCartManager.clearCartItems()
            self.shoppingListTableView.clearCartItems()
            self.delegate?.shoppingListViewControllerDidRequestDeleteAll(self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
