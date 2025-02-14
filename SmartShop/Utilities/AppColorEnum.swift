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
    case tint
    case top
    case collectionView
    case tfBg
    
    var color: UIColor {
        switch self {
        case .appBackground:
            return UIColor(hex: "#025F46")
        case .cellBackground:
            return UIColor(hex: "#E3F8CC")
        case .tint:
            return UIColor(hex: "#D4F3EA")
        case .top:
            return UIColor(hex: "#015F46")
        case .collectionView:
            return UIColor(hex: "#BBE199")
        case .tfBg:
            return UIColor(hex: "#024F43")
        }
    }
}
