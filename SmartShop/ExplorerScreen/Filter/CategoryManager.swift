//
//  CategoryManager.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import UIKit

protocol CategoryManagerProtocol: AnyObject {
    var categoryId: String? { get }
    func updateCategories(_ categories: [Product.Category])
}

final class CategoryManager {
    private enum Constants {
        static let buttonBorderWidth: CGFloat = 2
        static let buttonCornerRadius: CGFloat = 12
        static let buttonFontSize: CGFloat = 18
        static let horizontalStackViewSpacing: CGFloat = 10
        static let mainStackViewMargin: CGFloat = 16
        static let buttonContentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let buttonAdditionalWidth: CGFloat = 20
    }
    
    // MARK: Private Properties
    private lazy var categoryButtons: [UIButton] = []
    private var categories: [Product.Category] = []
    private weak var containerView: UIView?
    private var selectedCategoryId: String?
    
    // MARK: Init
    init(containerView: UIView) {
        self.containerView = containerView
    }
    
    // MARK: Private Methods
    private func createCategoryButtons() {
        categoryButtons.forEach { $0.removeFromSuperview() }
        categoryButtons.removeAll()
        
        guard let containerView = containerView else { return }
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Constants.horizontalStackViewSpacing
        verticalStackView.alignment = .leading
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        var uniqueCategoryNames = Set<String>()
        
        for category in categories {
            if !uniqueCategoryNames.contains(category.name) {
                uniqueCategoryNames.insert(category.name)
                
                let button = createButton(for: category)
                addButton(button, to: verticalStackView)
                categoryButtons.append(button)
            }
        }
    }
    
    private func createButton(for category: Product.Category) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(category.name, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize)
        button.setTitleColor(AppColorEnum.top.color, for: .normal)
        button.backgroundColor = AppColorEnum.collectionView.color
        button.layer.borderColor = AppColorEnum.tfBg.color.cgColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = Constants.buttonContentInsets
        return button
    }
    
    private func addButton(_ button: UIButton, to stackView: UIStackView) {
        if let currentRowStackView = stackView.arrangedSubviews.last as? UIStackView,
           canFitButton(button.intrinsicContentSize.width + Constants.buttonAdditionalWidth, in: currentRowStackView) {
            currentRowStackView.addArrangedSubview(button)
        } else {
            let newRowStackView = createNewRowStackView()
            newRowStackView.addArrangedSubview(button)
            stackView.addArrangedSubview(newRowStackView)
        }
    }
    
    private func canFitButton(_ buttonWidth: CGFloat, in stackView: UIStackView) -> Bool {
        let totalWidth = stackView.arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.width + Constants.horizontalStackViewSpacing }
        let availableWidth = (containerView?.bounds.width ?? 0) - 2 * Constants.mainStackViewMargin
        return totalWidth + buttonWidth <= availableWidth
    }
    
    private func createNewRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.horizontalStackViewSpacing
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: Action
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        categoryButtons.forEach { $0.layer.borderWidth = 0 }
        sender.layer.borderWidth = sender.layer.borderWidth == 0 ? Constants.buttonBorderWidth : 0
        
        if let index = categoryButtons.firstIndex(of: sender) {
            selectedCategoryId = ("\(categories[index].id)")
        }
    }
}

// MARK: - CategoryManagerProtocol
extension CategoryManager: CategoryManagerProtocol {
    var categoryId: String? { return selectedCategoryId }

    func updateCategories(_ categories: [Product.Category]) {
        self.categories = categories
        createCategoryButtons()
    }
}
