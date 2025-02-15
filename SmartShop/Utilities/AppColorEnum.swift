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
    case whiteForTxInFilter
    case top
    case collectionView
    case tfBg
    case lightWhite
    case salad
    case gray
    case lightGray

    var color: UIColor {
        switch self {
        case .appBackground:
            return UIColor(hex: "#025F46")
        case .cellBackground:
            return UIColor(hex: "#C9E7AB")
        case .whiteForTxInFilter:
            return UIColor(hex: "#D4F3EA")
        case .top:
            return UIColor(hex: "#015F46")
        case .collectionView:
            return UIColor(hex: "#BBE199")
        case .tfBg:
            return UIColor(hex: "#024F43")
        case .lightWhite:
            return UIColor(hex: "#EAEAEA")
        case .salad:
            return UIColor(hex: "#68CA21")
        case .gray:
            return UIColor(hex: "#BBBDBF")
        case .lightGray:
            return UIColor(hex: "#E5E5E5")
        }
    }
}
