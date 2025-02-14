//
//  EmptyStateViewController.swift
//  SmartShop
//
//  Created by Антон Стафеев on 14.02.2025.
//

import UIKit
import OSLog

enum EmptyState {
    case nothingFound
    case downloadError
    case none
}

protocol EmptyStateConfigurable {
    func configure(with state: EmptyState)
}

final class EmptyStateViewController: UIViewController {
    weak var delegate: EmptyStateViewDelegate?
    
    private lazy var emptyStateView = EmptyStateView()
    
    override func loadView() {
        view = emptyStateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyStateView.delegate = self
    }
}

// MARK: - EmtyStateConfigurable
extension EmptyStateViewController: EmptyStateConfigurable {
    func configure(with state: EmptyState) {
        switch state {
        case .nothingFound:
            emptyStateView.setEmptyState(image: UIImage(resource: .emptyStateNothing), retryButtonAlpha: 0, text: "Nothing managed to find anything")
        case .downloadError:
            emptyStateView.setEmptyState(image: UIImage(resource: .emptyStateDownloadError), retryButtonAlpha: 1.0, text: "There was an error when loading")
        case .none:
            Logger.emptyState.info("Data loaded successfully, no empty state to display")
        }
    }
}

// MARK: - EmptyStateViewDelegate
extension EmptyStateViewController: EmptyStateViewDelegate {
    func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
}
