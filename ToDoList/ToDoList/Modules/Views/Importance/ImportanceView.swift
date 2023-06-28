import UIKit

protocol ImportanceViewDelegate: AnyObject {
    func didSelectImportance(_ importance: ToDoItem.Importance)
}

final class ImportanceView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        
        static let titleLabelTopOffset: CGFloat = 16
        static let titleLabelLeadingOffset: CGFloat = 16
        static let titleLabelBottomOffset: CGFloat = 16
        
        static let containerViewLeadingOffset: CGFloat = 16
        static let containerViewTrailingOffset: CGFloat = 12
        
        static let segmentedViewTopOffset: CGFloat = 2
        static let segmentedViewBottomOffset: CGFloat = 2
        static let segmentedViewLeadingOffset: CGFloat = 2
        static let segmentedViewTrailingOffset: CGFloat = 2
    }
    
    // MARK: - Outlets
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = YandexFont.body.font
        label.text = "Важность"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = YandexColor.supportOverlay.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lowImportanceControl: ImportanceControl = {
        let control = ImportanceControl(importance: .low)
        control.addTarget(self, action: #selector(controlPressed), for: .touchUpInside)
        control.isHiddenSeparator = false
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var regularImportanceControl: ImportanceControl = {
        let control = ImportanceControl(importance: .regular)
        control.addTarget(self, action: #selector(controlPressed), for: .touchUpInside)
        control.isHiddenSeparator = false
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var highImportanceControl: ImportanceControl = {
        let control = ImportanceControl(importance: .high)
        control.addTarget(self, action: #selector(controlPressed), for: .touchUpInside)
        control.isHiddenSeparator = false
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
        
    // MARK: - Properties
    
    weak var delegate: ImportanceViewDelegate?
    
    var selectedImportance: ToDoItem.Importance = .regular {
        didSet {
            guard selectedImportance != oldValue else { return }
            delegate?.didSelectImportance(selectedImportance)
            setupSeparator()
        }
    }
    
    private lazy var importanceControls: [ImportanceControl] = [lowImportanceControl, regularImportanceControl, highImportanceControl]
    
    // MARK: - Initialization
    
    
    
    // MARK: - Setup
    
    private func setupView() {
        
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(containerView)
        
        containerView.addSubview(segmentedView)
        
        segmentedView.addArrangedSubview(lowImportanceControl)
        segmentedView.addArrangedSubview(regularImportanceControl)
        segmentedView.addArrangedSubview(highImportanceControl)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeadingOffset),
            titleLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelTopOffset),
            
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constants.containerViewLeadingOffset),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerViewTrailingOffset),
        
            segmentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.segmentedViewTopOffset),
            segmentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.segmentedViewTopOffset),
            segmentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.segmentedViewTrailingOffset),
            segmentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.segmentedViewBottomOffset),
        
        ])
    }
    
    private func setupSeparator() {
        importanceControls.forEach { control in
            let isSameImportance = control.importance == selectedImportance
            control.isSelected = isSameImportance
            control.isHiddenSeparator = isSameImportance
        }
        
        guard let index = ToDoItem.Importance.allCases.firstIndex(of: selectedImportance), index > 0 else { return }
        importanceControls[index - 1].isHiddenSeparator = true
    }
    
    
    // MARK: - Methods
    
    @objc private func controlPressed(_ sender: ImportanceControl) {
        selectedImportance = sender.importance
    }
}
