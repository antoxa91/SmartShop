//
//  ProductDetailView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit
import OSLog

protocol ProductDetailViewDelegate: AnyObject {
    func didTapAddToCart()
}

final class ProductDetailView: UIView {
    weak var delegate: ProductDetailViewDelegate?
    
    private enum Constants {
        static let defaultPadding: CGFloat = 8
        static let buttonHeight: CGFloat = 45
        static let imageHeightMultiplier: CGFloat = 0.56
        static let buttonWidthMultiplier: CGFloat = 0.56
        static let quantityViewWidthMultiplier: CGFloat = 0.35
    }
    
    private let imageLoader: ImageLoaderProtocol
    
    // MARK: Private UI Properties
    private let productImagePageViewController: ProductImagePageViewController

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
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.imagePadding = 16
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = .init(pointSize: 18, weight: .semibold)
        button.configuration = config
        
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityView = QuantityView()
    
    // MARK: Init
    init(frame: CGRect = .zero,
         imageLoader: ImageLoaderProtocol
    ) {
        self.imageLoader = imageLoader
        self.productImagePageViewController = ProductImagePageViewController(imageLoader: imageLoader)
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
        addSubviews(productImagePageViewController.view, scrollView, addToCartButton, quantityView)
        scrollView.addSubviews(contentView, categoryLabel, descriptionLabel, priceLabel)
        configureAddToCartButton(isAddedToCart: false)
    }
    
    private func configureAddToCartButton(isAddedToCart: Bool) {
        var config = addToCartButton.configuration
        if isAddedToCart {
            config?.baseBackgroundColor = AppColorEnum.lightGray.color
            config?.background.strokeWidth = 2
            config?.background.strokeColor = AppColorEnum.tfBg.color
            config?.baseForegroundColor = AppColorEnum.tfBg.color
            config?.image = nil
            let attributedTitle = AttributedString("To the Shopping List", attributes: .init([
                .font: UIFont.systemFont(ofSize: 19, weight: .semibold),
                .foregroundColor: AppColorEnum.tfBg.color
            ]))
            config?.attributedTitle = attributedTitle
            
            UIView.transition(with: self.addToCartButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.addToCartButton.setNeedsLayout()
                self.addToCartButton.layoutIfNeeded()
            })
        } else {
            config?.baseBackgroundColor = AppColorEnum.tfBg.color
            config?.image = UIImage(systemName: "cart")
            let attributedTitle = AttributedString("Add to Cart", attributes: .init([
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor: AppColorEnum.lightWhite.color
            ]))
            config?.attributedTitle = attributedTitle
        }
        addToCartButton.configuration = config
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImagePageViewController.view.topAnchor.constraint(equalTo: topAnchor),
            productImagePageViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImagePageViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImagePageViewController.view.heightAnchor.constraint(equalTo: heightAnchor,
                                                     multiplier: Constants.imageHeightMultiplier),
            
            scrollView.topAnchor.constraint(equalTo: productImagePageViewController.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Constants.defaultPadding),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Constants.defaultPadding),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Constants.defaultPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                                  constant: Constants.defaultPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: Constants.defaultPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -Constants.defaultPadding),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                            constant: Constants.defaultPadding),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Constants.defaultPadding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Constants.defaultPadding),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -Constants.defaultPadding),
            
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultPadding),
            addToCartButton.widthAnchor.constraint(equalTo: widthAnchor,
                                                   multiplier: Constants.buttonWidthMultiplier),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultPadding),
            addToCartButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            quantityView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultPadding),
            quantityView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: Constants.quantityViewWidthMultiplier),
            quantityView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultPadding),
            quantityView.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    // MARK: Action
    @objc private func addToCartButtonTapped() {
        configureAddToCartButton(isAddedToCart: true)
        delegate?.didTapAddToCart()
    }
}

// MARK: - ConfigurableViewProtocol
extension ProductDetailView: ConfigurableViewProtocol {
    typealias ConfigirationModel = Product
    
    func configure(with model: Product) {
        descriptionLabel.text = model.description
        priceLabel.text = "$ \(model.price)"
        categoryLabel.text = "Category -> \(model.category.name)"
        productImagePageViewController.configure(with: model.images)
    }
}
