//
//  BasketView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class BasketView: UIView {
    private lazy var basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.tintColor = AppColorEnum.label.color
        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = AppColorEnum.cellBackground.color
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(basketButton)
        
        NSLayoutConstraint.activate([
            basketButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            basketButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            basketButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            basketButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
    }
    
    @objc private func basketButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.basketButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.basketButton.transform = .identity
            }
        })
    }
}
