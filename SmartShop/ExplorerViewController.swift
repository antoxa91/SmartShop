//
//  ExplorerViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class ExplorerViewController: UIViewController {
    private lazy var explorerListView: ExplorerListView = {
        let explorerListView = ExplorerListView(networkService: self.networkService, imageLoader: self.imageLoader)
        return explorerListView
    }()
    private let networkService: ProductsLoader
    private let imageLoader: ImageLoaderProtocol
    
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
        view.backgroundColor = AppColorEnum.appBackground.color
        view.addSubviews(explorerListView)
        title = "Platzi Fake Store"
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

