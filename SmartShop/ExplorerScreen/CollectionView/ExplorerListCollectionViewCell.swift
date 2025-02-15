//
//  ExplorerListCollectionViewCell.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit
import OSLog

protocol ConfigurableViewProtocol {
    associatedtype ConfigirationModel
    func configure(with model: ConfigirationModel)
}

final class ExplorerListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ExplorerListCollectionViewCell.self)
    private var imageLoader: ImageLoaderProtocol?
    
    private let cornerRadius: CGFloat = 16
    
    // MARK: Private UI Propertie
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.cellBackground.color
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageLoader = ImageLoaderService()
        setupContentView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupContentView() {
        contentView.backgroundColor = AppColorEnum.cellBackground.color
        contentView.layer.cornerRadius = cornerRadius
        productImageView.layer.cornerRadius = cornerRadius
        contentView.addSubview(productImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productImageView.alpha = 0
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}


// MARK: - ConfigurableViewProtocol
extension ExplorerListCollectionViewCell: ConfigurableViewProtocol {
    typealias ConfigirationModel = Product
    
    func configure(with model: Product) {
        guard let cleanUrlString = model.images.first?.cleanedURLString(),
              let url = URL(string: cleanUrlString) else {
            Logger.cell.error("Error: Invalid URL for Image: \(model.images.first ?? "No image URL")")
            setPlaceholderImage()
            return
        }
        
        imageLoader?.fetchImage(with: url) { [weak self] image in
            DispatchQueue.main.async {
                guard let image else {
                    self?.setPlaceholderImage()
                    return
                }
                self?.productImageView.image = image
                UIView.animate(withDuration: 0.3, animations: {
                    self?.productImageView.alpha = 1
                })
            }
        }
    }
    
    private func setPlaceholderImage() {
        productImageView.image = .imageNotFound
        productImageView.alpha = 1
    }
}
