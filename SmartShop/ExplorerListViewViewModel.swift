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
    func didSelectProduct(_ character: Product)
}

protocol ProductFetchable {
    func fetchProducts()
    func filterByTitle(_ title: String?)
    func filterByParameters(_ parameters: FilterParameters)
}

final class ExplorerListViewViewModel: NSObject {
    public weak var delegate: ExplorerListViewViewModelDelegate?
    let networkService: ProductsLoader
    private var products: [Product] = []
    
    init(networkService: ProductsLoader) {
        self.networkService = networkService
    }
}

// MARK: - ProductFetchable
extension ExplorerListViewViewModel: ProductFetchable {
    func filterByParameters(_ parameters: FilterParameters) {
        networkService.filterByParameters(parameters) { [weak self] products in
            DispatchQueue.main.async {
                self?.products = products
                self?.delegate?.didLoadInitialProduct()
                print(products)
            }
        }
    }
    
    func filterByTitle(_ title: String?) {
        networkService.filterByTitle(title) { [weak self] products in
            DispatchQueue.main.async {
                self?.products = products
                self?.delegate?.didLoadInitialProduct()
                print(products)
                
            }
        }
    }
    
    func fetchProducts() {
        networkService.fetchInitialProducts {
            DispatchQueue.main.async {
                self.products = self.networkService.products
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
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExplorerListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.15)
    }
}

// MARK: - UITextFieldDelegate
extension ExplorerListViewViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        
        let searchHistory = SearchHistoryManager.shared.getSearchHistory()
        if let searchTextField = textField as? SearchTextField {
            searchTextField.dropdownTableView.updateSearchHistory(searchHistory)
        }
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
            self?.delegate?.didLoadInitialProduct()
        }
        
        SearchHistoryManager.shared.addSearchQuery(searchText)
        return true
    }
}
