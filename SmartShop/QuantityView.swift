//
//  QuantityView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 15.02.2025.
//

import UIKit

final class QuantityView: UIView {
    // MARK: Private UI Properties
    private lazy var counterLabel = ProductLabel(text: "1", font: .systemFont(ofSize: 18, weight: .semibold), textAlignment: .center)
    
    private let configForButton = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus", withConfiguration: configForButton), for: .normal)
        button.tintColor = .black
        button.backgroundColor = AppColorEnum.gray.color
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configForButton), for: .normal)
        button.tintColor = AppColorEnum.lightWhite.color
        button.backgroundColor = AppColorEnum.tfBg.color
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var counter = 1 {
        didSet {
            counterLabel.text = "\(counter)"
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = AppColorEnum.lightGray.color
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(minusButton, counterLabel, plusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            minusButton.topAnchor.constraint(equalTo: topAnchor),
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            minusButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            minusButton.widthAnchor.constraint(equalTo: heightAnchor),
            
            plusButton.topAnchor.constraint(equalTo: topAnchor),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            plusButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            plusButton.widthAnchor.constraint(equalTo: heightAnchor),
            
            counterLabel.topAnchor.constraint(equalTo: topAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor),
        ])
    }
    
    // MARK: Action
    @objc private func minusButtonTapped() {
        animateButton(minusButton)
        counter -= 1
        
        if counter <= 1 {
            minusButton.isEnabled = false
        }
    }
    
    @objc func plusButtonTapped() {
        animateButton(plusButton)
        counter += 1
        minusButton.isEnabled = true
    }
    
    // MARK: Animation
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
}
