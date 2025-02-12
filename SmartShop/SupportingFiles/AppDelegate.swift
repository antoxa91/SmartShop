//
//  AppDelegate.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit
import OSLog

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        do {
            let assembly = ExplorerViewControllerAssembly(networkService: NetworkService(),
                                                          imageLoader: ImageLoaderService())
            window?.rootViewController = try assembly.create()
        } catch {
            Logger.appDelegate.error("Cant create ExplorerViewController: \(error.localizedDescription)")
        }
        return true
    }
}

