//
//  SearchTextField.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class SearchTextField: UITextField {
    
    private lazy var searchIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = AppColorEnum.label.color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(systemName: "magnifyingglass")
        return imageView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = AppColorEnum.label.color
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        placeholder = "Search"
        backgroundColor = AppColorEnum.cellBackground.color
        layer.cornerRadius = 15
        returnKeyType = .search
        delegate = self
        
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
    
    @objc private func filterButtonTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.filterButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.filterButton.transform = .identity
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.searchIconView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.searchIconView.alpha = 0.7
        }
        
        textField.placeholder = ""
        rightView?.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.searchIconView.transform = .identity
            self.searchIconView.alpha = 1.0
        }
        
        textField.placeholder = "Search"
        rightView?.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = textField.text, !searchText.isEmpty else {
            
            return false
        }
        
        return true
    }
}
