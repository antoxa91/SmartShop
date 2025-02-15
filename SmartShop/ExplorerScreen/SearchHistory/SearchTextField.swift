//
//  SearchTextField.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

protocol BottomSheetDelegate: AnyObject {
    func showBottomSheet()
}

final class SearchTextField: UITextField {
    weak var bottomSheetDelegate: BottomSheetDelegate?
    
    // MARK: Private UI Properties
    private lazy var searchIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = AppColorEnum.lightWhite.color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(systemName: "magnifyingglass")
        return imageView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = AppColorEnum.lightWhite.color
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        let placeholderAttributes = NSAttributedString(
            string: "Search item or brands...",
            attributes: [.foregroundColor: AppColorEnum.lightWhite.color]
        )
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        attributedPlaceholder = placeholderAttributes
        defaultTextAttributes = textAttributes
        
        backgroundColor = AppColorEnum.tfBg.color
        layer.cornerRadius = 15
        returnKeyType = .search
        
        leftView = searchIconView
        leftViewMode = .always
        
        rightView = filterButton
        rightViewMode = .always
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        rect.size.width += 10
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }
    
    // MARK: Action
    @objc private func filterButtonTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.filterButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.filterButton.transform = .identity
            }
        }
        
        bottomSheetDelegate?.showBottomSheet()
    }
}
