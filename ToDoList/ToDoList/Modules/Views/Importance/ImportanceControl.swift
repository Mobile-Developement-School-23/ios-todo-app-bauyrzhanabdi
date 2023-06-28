import UIKit

final class ImportanceControl: UIControl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let newWidth: CGFloat = 48
        static let newHeight: CGFloat = 32
        static let cornerRadius: CGFloat = 8
        static let separatorViewTopOffset: CGFloat = 8
        static let separatorViewBottomOffset: CGFloat = 8
        static let sepatorViewWidth: CGFloat = 0.25
    }
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: Constants.newWidth, height: Constants.newHeight)
    }
    
    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            backgroundColor = isSelected ? YandexColor.backElevated.color : .clear
        }
    }
    
    var isHiddenSeparator: Bool = false {
        didSet {
            guard let separatorView = separatorView, isHiddenSeparator != oldValue else { return }
            separatorView.isHidden = isHiddenSeparator
        }
    }
    
    private(set) var importance: ToDoItem.Importance
    
    // MARK: - Outlets
    
    private lazy var infoView: UIView = {
        switch importance {
        case .low:
            let imageView = UIImageView()
            imageView.image = YandexImage.arrowDown.image
            imageView.center = center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        case .regular:
            let label = UILabel()
            label.font = YandexFont.subhead.font
            label.textColor = YandexColor.labelPrimary.color
            label.text = "нет"
            label.center = center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        case .high:
            let imageView = UIImageView()
            imageView.image = YandexImage.exclamationMark.image
            imageView.center = center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }()
    
    private lazy var separatorView: SeparatorView? = {
        guard importance != .high else { return nil }
        let view = SeparatorView()
        view.backgroundColor = YandexColor.supportSeparator.color
        return view
    }()
    
    // MARK: - Initialization
    
    init(importance: ToDoItem.Importance) {
        self.importance = importance
        super.init(frame: .zero)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupHierarchy() {
        addSubview(infoView)
        if let separatorView = separatorView {
            addSubview(separatorView)
        }
    }
    
    private func setupLayout() {
        if let separatorView = separatorView {
            NSLayoutConstraint.activate([
                separatorView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.separatorViewTopOffset),
                separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.separatorViewBottomOffset),
                separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
                separatorView.widthAnchor.constraint(equalToConstant: Constants.sepatorViewWidth)
            ])
        }
    }
}
