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
        print(#function)
    }
}
