//
//  ExplorerListView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class ExplorerListView: UIView {
    private enum Constants {
        static let sectionInset: CGFloat = 10
        static let elementInset: CGFloat = 8
        static let elementHeight: CGFloat = 40
    }
    
    private let viewModel = ExplorerListViewViewModel()
    
    // MARK: Private UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sectionInset, bottom: Constants.sectionInset, right: Constants.sectionInset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ExplorerListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorerListCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var searchTextField = SearchTextField()
    private lazy var basketView = BasketView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupCollectionView()
        setConstraints()
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
