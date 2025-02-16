//
//  String + Extension.swift
//  SmartShop
//
//  Created by Антон Стафеев on 16.02.2025.
//

import Foundation

extension String {
    func cleanedURLString() -> String {
        return self
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }
}
