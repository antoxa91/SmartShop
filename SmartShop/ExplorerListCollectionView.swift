//
//  ExplorerListCollectionView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit

final class ExplorerListCollectionView: UICollectionView {
    private let sectionInset: CGFloat = 10
    private let viewModel: ExplorerListViewViewModel

    init(_ viewModel: ExplorerListViewViewModel) {
        self.viewModel = viewModel

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: sectionInset, right: sectionInset)
        
        super.init(frame: .zero, collectionViewLayout: layout)

        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColorEnum.collectionView.color
        register(ExplorerListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorerListCollectionViewCell.identifier)
        dataSource = viewModel
        delegate = viewModel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 8
        layer.borderColor = AppColorEnum.collectionView.color.cgColor
        layer.cornerRadius = 14
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
