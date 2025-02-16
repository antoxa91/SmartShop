//
//  ShoppingListTableViewCell.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import UIKit
import OSLog

protocol ConfigurableShoppingListCell {
    associatedtype ConfigirationModel
    func configure(with model: Product, quantity: Int)
}

final class ShoppingListTableViewCell: UITableViewCell {
    static let identifier = String(describing: ShoppingListTableViewCell.self)
    private let imageLoader: ImageLoaderProtocol?
    
    private enum  Constants {
        static let imageCornerRadius: CGFloat = 8.0
        static let quantityViewWidthMultiplier: CGFloat = 0.30
        static let quantityViewHeightMultiplier: CGFloat = 0.25
        static let defaultPadding: CGFloat = 8
    }
    
    // MARK: Private UI Propertie
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.lightGreen.color
        return imageView
    }()
    
    private lazy var priceLabel = FilterLabel(text: "Price")
    private lazy var quantityView = QuantityView()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.imageLoader = ImageLoaderService()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupContentView() {
        contentView.backgroundColor = AppColorEnum.lightWhite.color
        contentView.addSubviews(productImageView, quantityView, priceLabel)
        productImageView.layer.cornerRadius = Constants.imageCornerRadius
        quantityView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = nil
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: Constants.defaultPadding),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: Constants.defaultPadding),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: -Constants.defaultPadding),
            productImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            quantityView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor,
                                                   constant: -Constants.defaultPadding*2),
            quantityView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: Constants.quantityViewWidthMultiplier),
            quantityView.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: Constants.quantityViewHeightMultiplier),
            quantityView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -Constants.defaultPadding),
        ])
    }
}


// MARK: - ConfigurableShoppingListCell
extension ShoppingListTableViewCell: ConfigurableShoppingListCell {
    typealias ConfigirationModel = CartItem
    
    func configure(with model: Product, quantity: Int) {
        priceLabel.text = "$ \(model.price)"
        quantityView.counter = quantity
        downloadImage(from: model)
    }
    
    private func downloadImage(from model: Product) {
        guard let cleanUrlString = model.images.first?.cleanedURLString(),
              let url = URL(string: cleanUrlString) else {
            Logger.cell.error("Error: Invalid URL in Shopping List for Image: \(model.images.first ?? "No image URL")")
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
            }
        }
    }
    
    private func setPlaceholderImage() {
        productImageView.image = .imageNotFound
    }
}

// MARK: - QuantityViewDelegate
extension ShoppingListTableViewCell: QuantityViewDelegate {
    func updateCounter(to quantity: Int) {
        quantityView.counter = quantity
    }
}
