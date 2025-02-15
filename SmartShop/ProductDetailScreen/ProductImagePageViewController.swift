import UIKit
import OSLog

protocol ConfigurableProductPageVC {
    func configure(with images: [String])
}

final class ProductImagePageViewController: UIPageViewController {
    // MARK: Private Properties
    private var images: [String] = []
    private var imageLoader: ImageLoaderProtocol
    private var viewControllersCache: [Int: UIViewController] = [:]
    
    private lazy var pageControl = UIPageControl()
    
    // MARK: Init
    init(imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
    }
    
    // MARK: Setup
    private func setupPageViewController() {
        dataSource = self
        delegate = self
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = AppColorEnum.top.color
        pageControl.pageIndicatorTintColor = AppColorEnum.gray.color
        pageControl.hidesForSinglePage = true
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createImageViewController(at index: Int) -> UIViewController {
        if let cachedViewController = viewControllersCache[index] {
            return cachedViewController
        }
        
        let viewController = UIViewController()
        let imageView = createImageView()
        viewController.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: viewController.view.heightAnchor),
        ])
        
        loadImage(for: imageView, at: index)
        
        viewControllersCache[index] = viewController
        return viewController
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func updatePageControl() {
        guard let currentViewController = viewControllers?.first,
              let index = viewControllersCache.first(where: { $0.value === currentViewController })?.key else { return }
        pageControl.currentPage = index
    }
    
    private func loadImage(for imageView: UIImageView, at index: Int) {
        guard index >= 0 && index < images.count,
              let url = URL(string: images[index].cleanedURLString()) else {
            Logger.productImagePageVC.error("Error: Invalid URL for Image: \(self.images[index])")
            pageControl.isHidden = true
            imageView.image = .imageNotFound
            return
        }
        
        imageLoader.fetchImage(with: url) { [weak imageView] image in
            DispatchQueue.main.async {
                imageView?.image = image ?? .imageNotFound
            }
        }
    }
}

// MARK: - ConfigurableProductPageVC
extension ProductImagePageViewController: ConfigurableProductPageVC {
    func configure(with images: [String]) {
        self.images = images
        pageControl.numberOfPages = images.count
        setViewControllers([createImageViewController(at: 0)], direction: .forward, animated: true, completion: nil)
        updatePageControl()
    }
}

// MARK: - UIPageViewControllerDataSource
extension ProductImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersCache.first(where: { $0.value === viewController })?.key else { return nil }
        if index == 0 { return nil }
        return createImageViewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersCache.first(where: { $0.value === viewController })?.key else { return nil }
        if index >= images.count - 1 { return nil }
        return createImageViewController(at: index + 1)
    }
}

// MARK: - UIPageViewControllerDelegate
extension ProductImagePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed { updatePageControl() }
    }
}
