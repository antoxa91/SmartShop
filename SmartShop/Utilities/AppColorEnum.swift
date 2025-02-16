//
//  AppColorEnum.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

enum AppColorEnum {
    case darkGreen
    case lightGreen
    case whiteForTxInFilter
    case green
    case middleLightGreen
    case veryDarkGreen
    case lightWhite
    case salad
    case gray
    case lightGray
    case black
    
    var color: UIColor {
        switch self {
        case .darkGreen:
            return UIColor(hex: "#025F46")
        case .lightGreen:
            return UIColor(hex: "#C9E7AB")
        case .whiteForTxInFilter:
            return UIColor(hex: "#D4F3EA")
        case .green:
            return UIColor(hex: "#015F46")
        case .middleLightGreen:
            return UIColor(hex: "#BBE199")
        case .veryDarkGreen:
            return UIColor(hex: "#024F43")
        case .lightWhite:
            return UIColor(hex: "#EAEAEA")
        case .salad:
            return UIColor(hex: "#68CA21")
        case .gray:
            return UIColor(hex: "#BBBDBF")
        case .lightGray:
            return UIColor(hex: "#E5E5E5")
        case .black:
            return .black
        }
    }
}
