//
//  FilterView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import UIKit

protocol FilterViewDataSource: AnyObject {
    var priceText: String? { get }
    var minPriceText: String? { get }
    var maxPriceText: String? { get }
    var categoryButtons: UIView { get }
    func setApplyButtonAction(target: Any?, action: Selector)
}


final class FilterView: UIView {
    private enum Constants {
        static let stackViewSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonBorderWidth: CGFloat = 2
        static let buttonCornerRadius: CGFloat = 12
        static let buttonFontSize: CGFloat = 18
        static let horizontalStackViewSpacing: CGFloat = 10
        static let mainStackViewMargin: CGFloat = 20
        static let buttonBottomMargin: CGFloat = -20
    }
    
    // MARK: UI Properties
    private lazy var priceTextField = FilterTF(placeholder: "Enter price")
    private lazy var minPriceTextField = FilterTF(placeholder: "Min price")
    private lazy var maxPriceTextField = FilterTF(placeholder: "Max price")
    
    private lazy var priceLabel = FilterLabel(text: "Price")
    private lazy var priceFromLabel = FilterLabel(text: "Price from")
    private lazy var priceToLabel = FilterLabel(text: "to")
    private lazy var categoryLabel = FilterLabel(text: "Categories")
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.buttonFontSize)
        button.setTitleColor(AppColorEnum.lightWhite.color, for: .normal)
        button.backgroundColor = AppColorEnum.top.color
        button.layer.borderColor = AppColorEnum.tfBg.color.cgColor
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var categoryButtonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = AppColorEnum.cellBackground.color
        let priceStackView = createHorizontalStackView(arrangedSubviews: [priceLabel, priceTextField])
        let minMaxPriceStackView = createHorizontalStackView(arrangedSubviews: [priceFromLabel, minPriceTextField, priceToLabel, maxPriceTextField])
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(minMaxPriceStackView)
        mainStackView.addArrangedSubview(categoryLabel)
        mainStackView.addArrangedSubview(categoryButtonsContainerView)
        addSubviews(mainStackView, applyButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.mainStackViewMargin),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mainStackViewMargin),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mainStackViewMargin),
            
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mainStackViewMargin),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mainStackViewMargin),
            applyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            applyButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: Constants.buttonBottomMargin)
        ])
    }
    
    private func createHorizontalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = Constants.horizontalStackViewSpacing
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }
}

// MARK: - FilterViewDataSource
extension FilterView: FilterViewDataSource {
    var priceText: String? { return priceTextField.text }
    var minPriceText: String? { return minPriceTextField.text }
    var maxPriceText: String? { return maxPriceTextField.text }
    var categoryButtons: UIView { return categoryButtonsContainerView }
    
    func setApplyButtonAction(target: Any?, action: Selector) {
        applyButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
