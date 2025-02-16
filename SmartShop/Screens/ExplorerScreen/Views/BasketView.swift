//
//  BasketView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class BasketView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 1
        static let buttonMultiplier: CGFloat = 0.6
        static let buttonScale: CGFloat = 1.2
        static let buttonTap: TimeInterval = 0.1
    }
    
    private lazy var basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.tintColor = AppColorEnum.lightWhite.color
        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupView() {
        backgroundColor = AppColorEnum.veryDarkGreen.color
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = AppColorEnum.lightWhite.color.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(basketButton)
        
        NSLayoutConstraint.activate([
            basketButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            basketButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            basketButton.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: Constants.buttonMultiplier),
            basketButton.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: Constants.buttonMultiplier)
        ])
    }
    
    // MARK: Action
    @objc private func basketButtonTapped() {
        UIView.animate(withDuration: Constants.buttonTap, animations: {
            self.basketButton.transform = CGAffineTransform(scaleX: Constants.buttonScale,
                                                            y: Constants.buttonScale)
        }, completion: { _ in
            UIView.animate(withDuration: Constants.buttonTap) {
                self.basketButton.transform = .identity
            }
        })
    }
}
