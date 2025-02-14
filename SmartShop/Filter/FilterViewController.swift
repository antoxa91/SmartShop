//
//  FilterViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func applyFilters(parameters: FilterParameters)
}

final class FilterViewController: UIViewController {
    weak var viewModel: ExplorerListViewViewModel?
    
    // MARK: Properties
    private lazy var filterView = FilterView()
    private lazy var categoryManager = CategoryManager(containerView: filterView.categoryButtons)
    private let networkService: ProductsLoader
    
    weak var delegate: FilterDelegate?
    
    // MARK: Init
    init(networkService: ProductsLoader) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = filterView
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        loadCategories()
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        filterView.setApplyButtonAction(target: self, action: #selector(applyFilters))
    }
    
    // MARK: Actions
    @objc private func applyFilters() {
        let parameters = FilterParameters(
            price: filterView.priceText,
            priceMin: filterView.minPriceText,
            priceMax: filterView.maxPriceText,
            categoryId: categoryManager.categoryId
        )
        delegate?.applyFilters(parameters: parameters)
        
        let categoryId = categoryManager.categoryId ?? ""
        viewModel?.updateSelectedCategories(categoryId)
        
        dismiss(animated: true)
    }
    
    // MARK: Load Categories
    private func loadCategories() {
        networkService.fetchInitialProducts { [weak self] in
            DispatchQueue.main.async {
                let categories = self?.networkService.products.map { $0.category } ?? []
                self?.categoryManager.updateCategories(categories)
            }
        }
    }
}
