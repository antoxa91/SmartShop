//
//  Logger + Extension.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import Foundation
import OSLog

extension Logger {
    private static var appIdentifier = Bundle.main.bundleIdentifier ?? ""
    
    static let network = Logger(subsystem: appIdentifier, category: "network")
    static let appDelegate = Logger(subsystem: appIdentifier, category: "appDelegate")
    static let cell = Logger(subsystem: appIdentifier, category: "cellForItemAt")
    static let imageLoader = Logger(subsystem: appIdentifier, category: "ImageLoader")
    static let emptyState = Logger(subsystem: appIdentifier, category: "emptyState")
    static let productDetailVC = Logger(subsystem: appIdentifier, category: "productDetailVC")
}
