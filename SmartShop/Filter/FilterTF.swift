//
//  FilterTF.swift
//  SmartShop
//
//  Created by Антон Стафеев on 13.02.2025.
//

import UIKit

final class FilterTF: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.borderStyle = .roundedRect
        self.backgroundColor = AppColorEnum.tint.color
        self.textColor = AppColorEnum.top.color
        self.keyboardType = .numberPad
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.textAlignment = .justified
    }
}
