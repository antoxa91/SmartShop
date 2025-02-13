//
//  ExplorerListView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

protocol ExplorerListViewDelegate: AnyObject {
    func presentBottomSheet(_ viewController: UIViewController)
}

final class ExplorerListView: UIView {
    private enum Constants {
        static let sectionInset: CGFloat = 10
        static let elementInset: CGFloat = 8
        static let elementHeight: CGFloat = 40
    }
    weak var delegate: ExplorerListViewDelegate?
    
    private let viewModel: ExplorerListViewViewModel
    private let imageLoader: ImageLoaderProtocol
    private var filterViewController: FilterViewController?
    
    // MARK: Private UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sectionInset, bottom: Constants.sectionInset, right: Constants.sectionInset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColorEnum.collectionView.color
        collectionView.register(ExplorerListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorerListCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var searchTextField = SearchTextField()
    private lazy var basketView = BasketView()
    
    // MARK: Init
    init(networkService: ProductsLoader, imageLoader: ImageLoaderProtocol) {
        self.viewModel = ExplorerListViewViewModel(networkService: networkService)
        self.imageLoader = imageLoader
        super.init(frame: .zero)
        setupSubviews()
        setupCollectionView()
        setConstraints()
        viewModel.delegate = self
        viewModel.fetchProducts()
        searchTextField.delegate = viewModel
        searchTextField.bottomSheetDelegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    private func setupSubviews() {
        addSubviews(collectionView, searchTextField, basketView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.layer.borderWidth = 8
        collectionView.layer.borderColor = AppColorEnum.collectionView.color.cgColor
        collectionView.layer.cornerRadius = 14
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.elementInset),
            searchTextField.trailingAnchor.constraint(equalTo: basketView.leadingAnchor, constant: -Constants.elementInset),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.elementHeight),
            
            basketView.topAnchor.constraint(equalTo: topAnchor),
            basketView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.elementInset),
            basketView.widthAnchor.constraint(equalToConstant: Constants.elementHeight),
            basketView.heightAnchor.constraint(equalToConstant: Constants.elementHeight),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.elementInset),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - ExplorerListViewViewModelDelegate
extension ExplorerListView: ExplorerListViewViewModelDelegate {
    func didLoadInitialProduct() {
        collectionView.reloadData()
    }
    
    func didLoadMoreProducts(with newIndexPaths: [IndexPath]) {
        collectionView.insertItems(at: newIndexPaths)
    }
    
    func didSelectProduct(_ character: Product) {
        //
    }
}

// MARK: - BottomSheetDelegate
extension ExplorerListView: BottomSheetDelegate {
    func showBottomSheet() {
        filterViewController = FilterViewController(networkService: viewModel.networkService)
        filterViewController?.delegate = self
        
        if let sheet = filterViewController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 32
            sheet.prefersGrabberVisible = true
        }
        
        delegate?.presentBottomSheet(filterViewController!)
    }
}

// MARK: - FilterDelegate
extension ExplorerListView: FilterDelegate {
    func applyFilters(parameters: FilterParameters) {
        viewModel.filterByParameters(parameters)
        collectionView.reloadData()
    }
}
