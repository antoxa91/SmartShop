import UIKit

protocol FilterDelegate: AnyObject {
    func applyFilters(parameters: FilterParameters)
}

final class FilterViewController: UIViewController {
    
    // MARK: - UI Properties
    private lazy var priceTextField = FilterTF(placeholder: "Enter price")
    private lazy var minPriceTextField = FilterTF(placeholder: "Min price")
    private lazy var maxPriceTextField = FilterTF(placeholder: "Max price")
    
    private lazy var priceLabel = FilterLabel(text: "Price")
    private lazy var priceFromLabel = FilterLabel(text: "Price from")
    private lazy var priceToLabel = FilterLabel(text: "to")
    private lazy var categoryLabel = FilterLabel(text: "Categories")

    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(AppColorEnum.tint.color, for: .normal)
        button.backgroundColor = AppColorEnum.top.color
        button.layer.borderColor = AppColorEnum.tfBg.color.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()

    weak var delegate: FilterDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = AppColorEnum.cellBackground.color
        
        let priceStackView = createHorizontalStackView(arrangedSubviews: [priceLabel, priceTextField])
        
        let minMaxPriceStackView = createHorizontalStackView(arrangedSubviews: [priceFromLabel, minPriceTextField, priceToLabel, maxPriceTextField])
        
        // Center categoryLabel
        let categoryContainerView = UIView()
        categoryContainerView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: categoryContainerView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor)
        ])
        
        let mainStackView = UIStackView(arrangedSubviews: [priceStackView, minMaxPriceStackView, categoryContainerView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // Configure applyButton
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ])
    }
    
    private func createHorizontalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }
    
    // MARK: - Actions
    @objc private func applyFilters() {
        var parameters = FilterParameters()
        
        if let priceText = priceTextField.text {
            parameters.price = priceText
        }
        
        if let minPriceText = minPriceTextField.text {
            parameters.priceMin = minPriceText
        }
        
        if let maxPriceText = maxPriceTextField.text {
            parameters.priceMax = maxPriceText
        }
        
        delegate?.applyFilters(parameters: parameters)
        dismiss(animated: true, completion: nil)
    }
}

final class FilterLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.font = .boldSystemFont(ofSize: 17)
        self.textColor = AppColorEnum.top.color
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

final class FilterTF: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.borderStyle = .roundedRect
        self.backgroundColor = AppColorEnum.tint.color
        self.textColor = AppColorEnum.top.color
        self.keyboardType = .numberPad
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
