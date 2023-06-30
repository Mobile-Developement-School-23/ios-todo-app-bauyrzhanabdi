import UIKit

final class DeadlineView: UIControl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let stackViewLeadingOffset: CGFloat = 16
        
        static let enableSwitchTopOffset: CGFloat = 12
        static let enableSwitchLeadingOffset: CGFloat = 16
        static let enableSwitchTrailingOffset: CGFloat = 12
        static let enableSwitchBottomOffset: CGFloat = 12
        static let enableSwitchHeight: CGFloat = 32
        static let enableSwitchWidth: CGFloat = 52
        
        static let separatorViewLeadingOffset: CGFloat = 16
        static let separatorViewTrailingOffset: CGFloat = 16
        static let separatorViewHeight: CGFloat = 0.5
    }
    
    // MARK: - Outlets
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = YandexFont.body.font
        label.text = "Сделать до"
        label.textColor = YandexColor.labelPrimary.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = YandexFont.footnote.font
        label.textColor = YandexColor.colorBlue.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enableSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.isUserInteractionEnabled = false
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private lazy var separatorView: SeparatorView = {
        let view = SeparatorView()
        return view
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            configure()
        }
    }
    
    var deadline: Date? {
        didSet {
            guard let deadline = deadline else { return }
            subtitleLabel.text = DateFormatter.format(date: deadline)
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        addSubview(stackView)
        addSubview(enableSwitch)
        addSubview(separatorView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.enableSwitchLeadingOffset),
            
            enableSwitch.topAnchor.constraint(equalTo: topAnchor, constant: Constants.enableSwitchTopOffset),
            enableSwitch.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor, constant: Constants.enableSwitchLeadingOffset),
            enableSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.enableSwitchTrailingOffset),
            enableSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.enableSwitchBottomOffset),
            enableSwitch.heightAnchor.constraint(equalToConstant: Constants.enableSwitchHeight),
            enableSwitch.widthAnchor.constraint(equalToConstant: Constants.enableSwitchWidth),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.separatorViewLeadingOffset),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.separatorViewTrailingOffset),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight)
        ])
    }
    
    // MARK: - Methods
    
    private func configure() {
        subtitleLabel.isHidden = !isSelected
        enableSwitch.isOn = isSelected
        enableSwitch.tintColor = isSelected ? YandexColor.colorGreen.color : YandexColor.supportOverlay.color
        separatorView.isHidden = !isSelected
    }
}
