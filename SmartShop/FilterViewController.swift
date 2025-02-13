//
//  FilterViewController2.swift
//  SmartShop
//
//  Created by Антон Стафеев on 12.02.2025.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func applyFilters(parameters: FilterParameters)
}

final class FilterViewController: UIViewController {
    
    // MARK: - UI Properties
    private let priceTextField = UITextField()
    private let minPriceTextField = UITextField()
    private let maxPriceTextField = UITextField()
    private let categoryTextField = UITextField()
    private let applyButton = UIButton(type: .system)
    
    weak var delegate: FilterDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        priceTextField.placeholder = "Price"
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .numberPad
        
        minPriceTextField.placeholder = "Min Price"
        minPriceTextField.borderStyle = .roundedRect
        minPriceTextField.keyboardType = .numberPad
        
        maxPriceTextField.placeholder = "Max Price"
        maxPriceTextField.borderStyle = .roundedRect
        maxPriceTextField.keyboardType = .numberPad
        
        categoryTextField.placeholder = "Category"
        categoryTextField.borderStyle = .roundedRect
        
        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.backgroundColor = .blue
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 8
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        
        [priceTextField, minPriceTextField, maxPriceTextField, categoryTextField, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            minPriceTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 20),
            minPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            minPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            minPriceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            maxPriceTextField.topAnchor.constraint(equalTo: minPriceTextField.bottomAnchor, constant: 20),
            maxPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            maxPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            maxPriceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            categoryTextField.topAnchor.constraint(equalTo: maxPriceTextField.bottomAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryTextField.heightAnchor.constraint(equalToConstant: 40),
            
            applyButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 40),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func applyFilters() {
        var parameters = FilterParameters()
        
        if let priceText = priceTextField.text {
            parameters.price = priceText
        }
        
        if let minPriceText = minPriceTextField.text {
            parameters.priceMin = minPriceText
        }
        
        if let maxPriceText = maxPriceTextField.text {
            parameters.priceMax = maxPriceText
        }
        
        if let categoryText = categoryTextField.text, !categoryText.isEmpty {
            parameters.categoryId = categoryText
        }
        
        delegate?.applyFilters(parameters: parameters)
        dismiss(animated: true, completion: nil)
    }
}
