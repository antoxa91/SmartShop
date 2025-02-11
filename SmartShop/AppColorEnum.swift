//
//  AppColorEnum.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

enum AppColorEnum {
    case appBackground
    case cellBackground
    case text
    
    var color: UIColor {
        switch self {
        case .appBackground:
            return .systemBackground
        case .cellBackground:
            return .secondarySystemBackground
        case .text:
            return .label
        }
    }
}
