//
//  ProductDetailViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit
import OSLog

final class ProductDetailViewController: UIViewController {
    private let product: Product
    private let imageLoader: ImageLoaderProtocol
    private lazy var productDetailView = ProductDetailView(imageLoader: imageLoader)
    
    // MARK: Init
    init(product: Product, imageLoader: ImageLoaderProtocol) {
        self.product = product
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    // MARK: Setup
    private func setupView() {
        title = product.title
        view.backgroundColor = AppColorEnum.lightWhite.color
        view.addSubview(productDetailView)
        productDetailView.configure(with: product)
        productDetailView.delegate = self
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .action, target: self, action:  #selector(shareProduct))
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func shareProduct() {
        let shareText = """
        Check out this product: \(product.title)
        
        Category: \(product.category.name)
        Description: \(product.description)
        Price: \(product.price) $
        """
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        Logger.productDetailVC.info("User shared product: \(self.product.title)")
    }
}

// MARK: - ProductDetailViewDelegate
extension ProductDetailViewController: ProductDetailViewDelegate {
    func didTapAddToCart(quantity: Int) {
        Logger.productDetailVC.info("User added to cart product: \(self.product.title) with quantity: \(quantity)")
        let cartItem = CartItem(product: product, quantity: quantity)
        ShoppingCartManager.shared.addCartItem(cartItem)
        let shoppingListVC = ShoppingListViewController(shoppingCartManager: ShoppingCartManager.shared)
        navigationController?.pushViewController(shoppingListVC, animated: true)
    }
}
