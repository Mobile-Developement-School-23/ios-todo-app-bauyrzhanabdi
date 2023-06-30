import UIKit

final class NotesTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelViewLeadingOffset: CGFloat = 0
        static let showButtonTrailingOffset: CGFloat = 0
    }
    
    // MARK: - Outlets
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — "
        label.textColor = YandexColor.labelTertiary.color
        label.font = YandexFont.subhead.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = YandexColor.labelTertiary.color
        label.font = YandexFont.subhead.font
        label.text = String(completedItems)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitleColor(YandexColor.colorBlue.color, for: .normal)
        button.setTitle("Показать", for: .normal)
        button.setTitle("Скрыть", for: .selected)
        button.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    var showButtonHandler: ((Bool) -> Void)?
    
    var completedItems: Int = 0 {
        didSet {
            descriptionLabel.text = String(completedItems)
        }
    }
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        contentView.addSubview(labelView)
        contentView.addSubview(showButton)
        
        labelView.addSubview(titleLabel)
        labelView.addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelViewLeadingOffset),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            
            showButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            showButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.showButtonTrailingOffset),
            showButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    // MARK: - Methods
    
    @objc func showButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        showButtonHandler?(sender.isSelected)
    }
}
