//
//  LoadingFooter.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit

final class LoadingFooter: UICollectionReusableView {
    static let identifier = String(describing: LoadingFooter.self)
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = AppColorEnum.veryDarkGreen.color
        return indicator
    }()
    
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingIndicator)
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
