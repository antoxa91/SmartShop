//
//  ExplorerViewControllerAssembly.swift
//  SmartShop
//
//  Created by Антон Стафеев on 12.02.2025.
//

import UIKit

struct ExplorerViewControllerAssembly {
    let networkService: ProductsLoader
    let imageLoader: ImageLoaderProtocol
    
    func create() throws -> UIViewController {
        let vc = ExplorerViewController(networkService: networkService, imageLoader: imageLoader)
        let navVC = UINavigationController(rootViewController: vc)
        configureNavigationBarAppearance()
        
        return navVC
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorEnum.appBackground.color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
