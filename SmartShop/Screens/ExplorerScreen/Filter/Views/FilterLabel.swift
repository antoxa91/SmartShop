//
//  FilterLabel.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import UIKit

final class FilterLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.font = .boldSystemFont(ofSize: 17)
        self.textColor = AppColorEnum.green.color
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
