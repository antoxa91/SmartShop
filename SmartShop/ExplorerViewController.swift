//
//  ExplorerViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 11.02.2025.
//

import UIKit

final class ExplorerViewController: UIViewController {
    private lazy var explorerListView = ExplorerListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setConstraints()
    }
    
    // MARK: Setup
    private func setupView() {
        view.backgroundColor = AppColorEnum.appBackground.color
        view.addSubviews(explorerListView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            explorerListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            explorerListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            explorerListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            explorerListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

