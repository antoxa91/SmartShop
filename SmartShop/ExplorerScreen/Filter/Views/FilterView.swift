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
}

protocol FilterViewDelegate: AnyObject {
    func setApplyButtonAction()
    func resetFilters()
}

final class FilterView: UIView {
    private enum Constants {
        static let stackViewSpacing: CGFloat = 20
        static let horizontalStackViewSpacing: CGFloat = 10
        static let mainStackViewMargin: CGFloat = 20
        static let applyButtonHeight: CGFloat = 40
        static let applyButtonBorderWidth: CGFloat = 2
        static let applyButtonCornerRadius: CGFloat = 12
        static let applyButtonFontSize: CGFloat = 18
        static let applyButtonBottomMargin: CGFloat = -8
        static let applyButtonWidthMultiplier = 0.6
        static let resetButtonWidth: CGFloat = 40
    }
    weak var delegate: FilterViewDelegate?
    // MARK: UI Properties
    private lazy var priceTextField = FilterTF(placeholder: "Enter price")
    private lazy var minPriceTextField = FilterTF(placeholder: "Min price")
    private lazy var maxPriceTextField = FilterTF(placeholder: "Max price")
    
    private lazy var priceLabel = FilterLabel(text: "Price")
    private lazy var priceFromLabel = FilterLabel(text: "Price from")
    private lazy var priceToLabel = FilterLabel(text: "to")
    private lazy var categoryLabel = FilterLabel(text: "Filter by Categories:")
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.layer.cornerRadius = Constants.resetButtonWidth / 2
        button.setImage(.init(systemName: "arrow.clockwise"), for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.applyButtonFontSize)
        button.setTitleColor(AppColorEnum.lightWhite.color, for: .normal)
        button.backgroundColor = AppColorEnum.top.color
        button.layer.borderColor = AppColorEnum.tfBg.color.cgColor
        button.layer.borderWidth = Constants.applyButtonBorderWidth
        button.layer.cornerRadius = Constants.applyButtonCornerRadius
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
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
        addSubviews(mainStackView, applyButton, resetButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                             constant: Constants.mainStackViewMargin/2),
            resetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mainStackViewMargin),
            resetButton.heightAnchor.constraint(equalToConstant: Constants.resetButtonWidth),
            resetButton.widthAnchor.constraint(equalToConstant: Constants.resetButtonWidth),
            
            mainStackView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mainStackViewMargin),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -Constants.mainStackViewMargin),
            
            applyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            applyButton.widthAnchor.constraint(equalTo: widthAnchor,
                                               multiplier: Constants.applyButtonWidthMultiplier),
            applyButton.heightAnchor.constraint(equalToConstant: Constants.applyButtonHeight),
            applyButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor,
                                                constant: Constants.applyButtonBottomMargin)
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
    
    // MARK: Action
    @objc private func resetButtonTapped() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 0.3
        rotationAnimation.repeatCount = 1
        resetButton.layer.add(rotationAnimation, forKey: "rotationAnimation")
        delegate?.resetFilters()
    }
    
    @objc private func applyButtonTapped() {
        delegate?.setApplyButtonAction()
    }
}

// MARK: - FilterViewDataSource
extension FilterView: FilterViewDataSource {
    var priceText: String? { return priceTextField.text }
    var minPriceText: String? { return minPriceTextField.text }
    var maxPriceText: String? { return maxPriceTextField.text }
    var categoryButtons: UIView { return categoryButtonsContainerView }
}
