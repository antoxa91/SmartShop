//
//  ExplorerViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class ExplorerViewController: UIViewController {
    // MARK: Private Properties
    private let networkService: ProductsLoader
    private let imageLoader: ImageLoaderProtocol
    
    private lazy var explorerListView: ExplorerListView = {
        let explorerListView = ExplorerListView(networkService: self.networkService,
                                                imageLoader: self.imageLoader)
        explorerListView.delegate = self
        return explorerListView
    }()
    
    // MARK: Init
    init(networkService: ProductsLoader, imageLoader: ImageLoaderProtocol) {
        self.networkService = networkService
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
        view.backgroundColor = AppColorEnum.darkGreen.color
        view.addSubviews(explorerListView)
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            explorerListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            explorerListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            explorerListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            explorerListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - ExplorerListViewDelegate
extension ExplorerViewController: ExplorerListViewDelegate {
    func pushDetailVC(_ productListView: ExplorerListView, didSelectProduct product: Product) {
        let detailVC = ProductDetailViewController(product: product, imageLoader: imageLoader)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func presentBottomSheet(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func pushShoppingListViewController() {
        let shoppingListVC = ShoppingListViewController(shoppingCartManager: ShoppingCartManager.shared)
        navigationController?.pushViewController(shoppingListVC, animated: true)
    }
}
