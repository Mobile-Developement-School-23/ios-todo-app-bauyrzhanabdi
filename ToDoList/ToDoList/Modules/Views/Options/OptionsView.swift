import UIKit

protocol OptionsViewDelegate: AnyObject {
    func didSelectImportance(_ importance: ToDoItem.Importance)
    func didSelectDeadline(_ date: Date?)
}

final class OptionsView: UIStackView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Outlets
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var importanceView: ImportanceView = {
        let view = ImportanceView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: SeparatorView = {
        let view = SeparatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    weak var delegate: OptionsViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = YandexColor.backSecondary.color
    }
    
    private func setupHierarchy() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(importanceView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Methods
}

// MARK: - Delegate Extensions

extension OptionsView: ImportanceViewDelegate {
    func didSelectImportance(_ importance: ToDoItem.Importance) {
        delegate?.didSelectImportance(importance)
    }
}
