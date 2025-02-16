//
//  ExplorerListView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit
import OSLog

protocol ExplorerListViewDelegate: AnyObject {
    func presentBottomSheet(_ viewController: UIViewController)
    func pushDetailVC(_ productListView: ExplorerListView,
                      didSelectProduct product: Product)
}

final class ExplorerListView: UIView {
    private enum Constants {
        static let elementInset: CGFloat = 8
        static let elementHeight: CGFloat = 40
    }
    
    weak var delegate: ExplorerListViewDelegate?
    
    private let viewModel: ExplorerListViewViewModel
    private let imageLoader: ImageLoaderProtocol
    
    // MARK: Private UI Properties
    private var filterViewController: FilterViewController?
    private lazy var dropdownTableView = SearchHistoryTableView()
    private lazy var explorerListCollectionView = ExplorerListCollectionView(viewModel)
    
    private lazy var searchTextField = SearchTextField()
    private lazy var basketView = BasketView()
    
    // MARK: Init
    init(networkService: ProductsLoader, imageLoader: ImageLoaderProtocol) {
        self.viewModel = ExplorerListViewViewModel(networkService: networkService)
        self.imageLoader = imageLoader
        super.init(frame: .zero)
        setupSubviews()
        setConstraints()
        configureViewModel()
        configureSearchTextField()
        setupTapGestureRecognizer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupSubviews() {
        addSubviews(explorerListCollectionView, searchTextField, basketView, dropdownTableView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndSearchHistory))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    private func configureViewModel() {
        viewModel.delegate = self
        viewModel.fetchProducts()
        viewModel.dropdownTableView = dropdownTableView
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = viewModel
        searchTextField.bottomSheetDelegate = self
        dropdownTableView.searchHistoryTableViewDelegate = self
    }
    
    @objc private func dismissKeyboardAndSearchHistory(_ gesture: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.dropdownTableView.alpha = 0
        }
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.elementInset),
            searchTextField.trailingAnchor.constraint(equalTo: basketView.leadingAnchor, constant: -Constants.elementInset),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.elementHeight),
            
            dropdownTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.elementInset),
            dropdownTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.elementInset),
            dropdownTableView.trailingAnchor.constraint(equalTo: basketView.leadingAnchor, constant: -Constants.elementInset),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 150),
            
            basketView.topAnchor.constraint(equalTo: topAnchor),
            basketView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.elementInset),
            basketView.widthAnchor.constraint(equalToConstant: Constants.elementHeight),
            basketView.heightAnchor.constraint(equalToConstant: Constants.elementHeight),
            
            explorerListCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.elementInset),
            explorerListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            explorerListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            explorerListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - ExplorerListViewViewModelDelegate
extension ExplorerListView: ExplorerListViewViewModelDelegate {
    func didUpdateState(_ state: EmptyState) {
        switch state {
        case .nothingFound:
            showEmptyState(with: .nothingFound)
        case .downloadError:
            showEmptyState(with: .downloadError)
        case .none:
            Logger.emptyState.info("Data loaded successfully, no empty state to display.")
        }
    }
    
    func showEmptyState(with type: EmptyState) {
        let emptyStateVC = EmptyStateViewController()
        emptyStateVC.configure(with: type)
        emptyStateVC.delegate = self
        
        if let sheet = emptyStateVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 32
        }
        
        delegate?.presentBottomSheet(emptyStateVC)
    }
    
    func didLoadInitialProduct() {
        explorerListCollectionView.reloadData()
    }
    
    func didLoadMoreProducts(with newIndexPaths: [IndexPath]) {
        explorerListCollectionView.performBatchUpdates {
            self.explorerListCollectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectProduct(_ product: Product) {
        delegate?.pushDetailVC(self, didSelectProduct: product)
    }
}

// MARK: - BottomSheetDelegate
extension ExplorerListView: BottomSheetDelegate {
    func showBottomSheet() {
        filterViewController = FilterViewController(networkService: viewModel.networkService)
        filterViewController?.viewModel = viewModel
        
        guard let filterViewController else { return }
        filterViewController.delegate = self
        
        if let sheet = filterViewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 32
            sheet.prefersGrabberVisible = true
        }
        
        delegate?.presentBottomSheet(filterViewController)
    }
}

// MARK: - FilterDelegate
extension ExplorerListView: FilterDelegate {
    func applyFilters(parameters: FilterParameters) {
        viewModel.filterByParameters(parameters)
        explorerListCollectionView.reloadData()
    }
}

// MARK: - SearchHistoryTableViewDelegate
extension ExplorerListView: SearchHistoryTableViewDelegate {
    func didSelectSearchHistoryItem(_ item: String) {
        searchTextField.text = item
        UIView.animate(withDuration: 0.3) {
            self.dropdownTableView.alpha = 0
        }
        viewModel.filterByTitle(item)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ExplorerListView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        return !dropdownTableView.frame.contains(location)
    }
}


// MARK: - EmptyStateViewDelegate
extension ExplorerListView: EmptyStateViewDelegate {
    func retryButtonTapped() {
        viewModel.fetchProducts()
    }
}
