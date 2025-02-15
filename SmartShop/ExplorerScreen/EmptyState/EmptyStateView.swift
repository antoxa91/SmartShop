//
//  EmptyStateView.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit

protocol EmptyStateViewDelegate: AnyObject {
    func retryButtonTapped()
}

final class EmptyStateView: UIView {
    private enum ConstraintConstants {
        static let imageHeight: CGFloat = 263
        static let retryButtonBottom: CGFloat = 40
        static let buttonHeight: CGFloat = 42
        static let buttonWidth: CGFloat = 220
    }
    
    weak var delegate: EmptyStateViewDelegate?
    
    // MARK: Private UI Properties
    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .emptyStateNothing)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = AppColorEnum.tfBg.color
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 2
        btn.layer.borderColor = AppColorEnum.lightWhite.color.cgColor
        btn.setTitle("Retry", for: .normal)
        btn.setTitleColor(AppColorEnum.lightWhite.color, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColorEnum.lightWhite.color
        label.font = .italicSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Nothing managed to find anything"
        return label
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
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
        backgroundColor = AppColorEnum.appBackground.color
        addSubviews(emptyStateImageView, retryButton, statusLabel)
    }
    
    @objc private func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyStateImageView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: ConstraintConstants.imageHeight),
            emptyStateImageView.widthAnchor.constraint(equalTo: heightAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            statusLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor,
                                                constant: -ConstraintConstants.buttonHeight),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: ConstraintConstants.buttonWidth),
            retryButton.heightAnchor.constraint(equalToConstant: ConstraintConstants.buttonHeight),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -ConstraintConstants.buttonHeight)
        ])
    }
    
    func setEmptyState(image: UIImage?, retryButtonAlpha: CGFloat, text: String) {
        emptyStateImageView.image = image
        retryButton.alpha = retryButtonAlpha
        statusLabel.text = text
    }
}
