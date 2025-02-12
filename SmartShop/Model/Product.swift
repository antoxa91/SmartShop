//
//  Product.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    let category: Category
    
    struct Category: Decodable {
        let id: Int
        let name: String
        let image: String
    }
}
