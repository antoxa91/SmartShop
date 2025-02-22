//
//  ProductLabel.swift
//  SmartShop
//
//  Created by Антон Стафеев on 15.02.2025.
//

import UIKit

final class ProductLabel: UILabel {
    init(text: String = "", textColor: UIColor = AppColorEnum.black.color, font: UIFont, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = textAlignment
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
