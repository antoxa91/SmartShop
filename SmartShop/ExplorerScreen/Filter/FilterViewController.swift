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
        loadCategories()
        filterView.delegate = self
    }
    
    // MARK: Load Categories
    private func loadCategories() {
        networkService.fetchCategories { [weak self] in
            DispatchQueue.main.async {
                guard let categories = self?.networkService.categories else { return }
                self?.categoryManager.updateCategories(categories)
            }
        }
    }
}

// MARK: - FilterViewDelegate
extension FilterViewController: FilterViewDelegate {
    func setApplyButtonAction() {
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
    
    func resetFilters() {
        let param = FilterParameters(
            price: "",
            priceMin: "",
            priceMax: "",
            categoryId: ""
        )
        
        viewModel?.filterByParameters(param)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}
