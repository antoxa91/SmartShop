//
//  ProductDetailView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit
import OSLog

final class ProductDetailView: UIView {
    private let imageLoader: ImageLoaderProtocol

    // MARK: Private UI Properties
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.appBackground.color
        return imageView
    }()
    
    private lazy var descriptionLabel = ProductLabel(font: .systemFont(ofSize: 18, weight: .bold),
                                                     numberOfLines: 0)
    private lazy var priceLabel = ProductLabel(textColor: AppColorEnum.salad.color,
                                               font: .systemFont(ofSize: 17, weight: .black))
    private lazy var categoryLabel = ProductLabel(font: .systemFont(ofSize: 15, weight: .regular))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// TODO: - обработать нажатие - добавить action, измение цвета, текста,
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.image = UIImage(systemName: "cart")
        config.imagePadding = 7
        config.imagePlacement = .leading
        config.title = "Add to Cart"
        config.baseBackgroundColor = AppColorEnum.tfBg.color
        config.buttonSize = .medium
        button.configuration = config
        config.baseForegroundColor = AppColorEnum.lightWhite.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityView = QuantityView()
    
    // MARK: Init
    init(frame: CGRect = .zero,
         imageLoader: ImageLoaderProtocol
    ) {
        self.imageLoader = imageLoader
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColorEnum.lightWhite.color
        addSubviews(productImageView, scrollView, addToCartButton, quantityView)
        scrollView.addSubviews(contentView, categoryLabel, descriptionLabel, priceLabel)
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),

            scrollView.topAnchor.constraint(equalTo: productImageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addToCartButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 45),

            quantityView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            quantityView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            quantityView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            quantityView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }

}

// MARK: - ConfigurableViewProtocol
extension ProductDetailView: ConfigurableViewProtocol {
    typealias ConfigirationModel = Product
    
    func configure(with model: Product) {
        descriptionLabel.text = model.description
        priceLabel.text = "$ \(model.price)"
        categoryLabel.text = "Category -> \(model.category.name)"
        fetchProductImage(model: model)
    }
    
    private func fetchProductImage(model: Product) {
        guard let imageUrlString = model.images.first, let url = URL(string: imageUrlString) else {
            Logger.cell.error("Error: Invalid URL for Image: \(model.images.first ?? "No image URL")")
            setPlaceholderImage()
            return
        }
        
        imageLoader.fetchImage(with: url) { [weak self] image in
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
