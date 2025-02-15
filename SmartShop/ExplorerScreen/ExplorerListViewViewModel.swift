//
//  ExplorerListViewViewModel.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit
import OSLog

protocol ExplorerListViewViewModelDelegate: AnyObject {
    func didLoadInitialProduct()
    func didLoadMoreProducts(with newIndexPaths: [IndexPath])
    func didSelectProduct(_ product: Product)
    func didUpdateState(_ state: EmptyState)
}

protocol ProductFetchable {
    func fetchProducts()
    func filterByTitle(_ title: String?)
    func filterByParameters(_ parameters: FilterParameters)
}

final class ExplorerListViewViewModel: NSObject {
    weak var delegate: ExplorerListViewViewModelDelegate?
    weak var dropdownTableView: SearchHistoryTableView?
    
    let networkService: ProductsLoader
    private var products: [Product] = []
    
    private var currentState: EmptyState = .none {
        didSet {
            delegate?.didUpdateState(currentState)
        }
    }
    
    private var selectedCategorie = ""
    
    init(networkService: ProductsLoader) {
        self.networkService = networkService
    }
    
    func updateSelectedCategories(_ categorie: String) {
        selectedCategorie = categorie
        fetchProducts()
    }
}

// MARK: - ProductFetchable
extension ExplorerListViewViewModel: ProductFetchable {
    func filterByParameters(_ parameters: FilterParameters) {
        networkService.filterByParameters(parameters) { [weak self] products in
            DispatchQueue.main.async {
                self?.updateProducts(with: products)
            }
        }
    }
    
    func filterByTitle(_ title: String?) {
        networkService.filterByTitle(title) { [weak self] products in
            DispatchQueue.main.async {
                self?.updateProducts(with: products)
            }
        }
    }
    
    private func updateProducts(with products: [Product]) {
        self.products = products
        self.currentState = self.products.isEmpty ? .nothingFound : .none
        delegate?.didLoadInitialProduct()
    }
    
    func fetchProducts() {
        networkService.fetchInitialProducts {
            DispatchQueue.main.async {
                self.products = self.networkService.products
                self.currentState = self.products.isEmpty == true ? .downloadError : .none
                self.delegate?.didLoadInitialProduct()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ExplorerListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorerListCollectionViewCell.identifier, for: indexPath) as? ExplorerListCollectionViewCell else {
            Logger.cell.error("Failed to dequeue ExplorerListCollectionViewCell")
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooter.identifier, for: indexPath) as? LoadingFooter else {
            Logger.cell.warning("Cant create LoadingFooter")
            return UICollectionReusableView()
        }
        
        footer.isAnimating = products.count > 8
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let product = products[indexPath.row]
        delegate?.didSelectProduct(product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExplorerListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth(for: collectionView)
        return CGSize(width: width, height: width * 1.15)
    }
    
    private func calculateWidth(for collectionView: UICollectionView) -> CGFloat {
        switch selectedCategorie {
        case "1", "2":
            return collectionView.bounds.width
        default:
            return (collectionView.bounds.width - 30) / 2
        }
    }
}

// MARK: UIScrollViewDelegate
extension ExplorerListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            self.downloadAdditionalProducts()
        }
    }
    
    private func downloadAdditionalProducts() {
        networkService.fetchAdditionalProducts { [weak self] indexPathsToAdd in
            guard let self else { return }
            DispatchQueue.main.async {
                self.products = self.networkService.products
                self.delegate?.didLoadMoreProducts(with: indexPathsToAdd)
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension ExplorerListViewViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        UIView.animate(withDuration: 0.3, animations: {
            self.dropdownTableView?.alpha = 0.9
        }, completion: { _ in
            self.dropdownTableView?.updateSearchHistory(SearchHistoryManager.shared.getSearchHistory())
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Search item or brands..."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text, !searchText.isEmpty else {
            fetchProducts()
            return false
        }
        
        networkService.filterByTitle(searchText) { [weak self] products in
            self?.products = products
            self?.currentState = self?.products.isEmpty == true ? .nothingFound : .none
            self?.delegate?.didLoadInitialProduct()
            self?.selectedCategorie = ""
        }
        
        SearchHistoryManager.shared.addSearchQuery(searchText)
        dropdownTableView?.alpha = 0
        return true
    }
}
