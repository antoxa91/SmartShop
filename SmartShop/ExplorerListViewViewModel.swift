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
}

final class ExplorerListViewViewModel: NSObject {
    private let networkService: ProductsLoader
    public weak var delegate: ExplorerListViewViewModelDelegate?
    private var products: [Product] = []
    
    init(networkService: ProductsLoader) {
        self.networkService = networkService
    }
}

// MARK: - ProductFetchable
extension ExplorerListViewViewModel: ProductFetchable {
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


extension ExplorerListViewViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Search item or brands..."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text, !searchText.isEmpty else {
            products = []
            delegate?.didLoadInitialProduct()
            return false
        }
        
        networkService.filterBy(title: searchText, parameters: nil) { [weak self] products in
            self?.products = products
            self?.delegate?.didLoadInitialProduct()
        }
        
        return true
    }
}
