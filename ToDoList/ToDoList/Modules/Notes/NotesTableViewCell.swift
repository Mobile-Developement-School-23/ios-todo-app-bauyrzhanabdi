import UIKit

protocol NotesTableViewCellDelegate: AnyObject {
    func updateItem(_ item: ToDoItem)
}

final class NotesTableViewCell: UITableViewCell {
    
    // MARK: - Private Enum
    
    private enum Constants {
        static let radioButtonLeadingOffset: CGFloat = 8
        static let radioButtonHeight: CGFloat = 24
        static let radioButtonWidth: CGFloat = 24
        
        static let infoStackViewLeadingOffset: CGFloat = 8
        static let infoStackViewTrailingOffset: CGFloat = 8
        
        static let importanceIconViewWidth: CGFloat = 16
        
        static let importanceIconHeight: CGFloat = 20
        
        static let calendarIconHeight: CGFloat = 16
        static let calendarIconWidth: CGFloat = 16
        
        static let chevronIconTrailingOffset: CGFloat = 8
        static let chevronIconHeight: CGFloat = 12
        static let chevronIconWidth: CGFloat = 7
        
        static let separatorViewHeight: CGFloat = 0.5
    }
    
    // MARK: - Outlets
    
    private lazy var radioButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.isSelected = false
        button.setImage(YandexImage.radioButtonOff.image, for: .normal)
        button.setImage(YandexImage.radioButtonOn.image, for: .selected)
        button.addTarget(self, action: #selector(radioButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.font = YandexFont.body.font
        label.textColor = YandexColor.labelPrimary.color
        label.text = "Купить что-то"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var importanceIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = YandexImage.exclamationMark.image
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var importanceIconView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = YandexFont.subhead.font
        label.textColor = YandexColor.labelTertiary.color
        label.text = "14 июня"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = YandexImage.calendar.image
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var deadlineView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var chevronIcon: UIImageView = {
        let view = UIImageView()
        view.image = YandexImage.chevron.image
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: SeparatorView = {
        let view = SeparatorView()
        view.isHidden = false
        return view
    }()
    
    
    // MARK: - Properties
    
    private var item: ToDoItem?
    private var buttonPressedHandler: ((String) -> Void)?
    weak var delegate: NotesTableViewCellDelegate?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
//        accessoryType = .disclosureIndicator
    }
    
    private func setupHierarchy() {
        contentView.addSubview(radioButton)
        contentView.addSubview(infoStackView)
        contentView.addSubview(chevronIcon)
        contentView.addSubview(separatorView)
        
        infoStackView.addArrangedSubview(importanceIconView)
        infoStackView.addArrangedSubview(noteStackView)
        
        importanceIconView.addSubview(importanceIcon)
        
        noteStackView.addArrangedSubview(noteLabel)
        noteStackView.addArrangedSubview(deadlineView)
        
        deadlineView.addSubview(calendarIcon)
        deadlineView.addSubview(deadlineLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.radioButtonLeadingOffset),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonWidth),
            
            infoStackView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.infoStackViewLeadingOffset),
            infoStackView.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -Constants.infoStackViewTrailingOffset),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            importanceIconView.centerYAnchor.constraint(equalTo: infoStackView.centerYAnchor),
            importanceIconView.widthAnchor.constraint(equalToConstant: Constants.importanceIconViewWidth),
            
            importanceIcon.centerYAnchor.constraint(equalTo: importanceIconView.centerYAnchor),
            importanceIcon.heightAnchor.constraint(equalToConstant: Constants.importanceIconHeight),
            
            noteStackView.centerYAnchor.constraint(equalTo: infoStackView.centerYAnchor),
            
            calendarIcon.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor),
            calendarIcon.heightAnchor.constraint(equalTo: deadlineLabel.heightAnchor, multiplier: 1.0),
            calendarIcon.widthAnchor.constraint(equalTo: deadlineLabel.heightAnchor, multiplier: 1.0),
            
            deadlineLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor),
            deadlineLabel.topAnchor.constraint(equalTo: deadlineView.topAnchor),
            deadlineLabel.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor),
            
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.chevronIconTrailingOffset),
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.heightAnchor.constraint(equalToConstant: Constants.chevronIconHeight),
            chevronIcon.widthAnchor.constraint(equalToConstant: Constants.chevronIconWidth),
            
            separatorView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight)
        ])
    }
    
    // MARK: - Methods
    
    func configure(with item: ToDoItem, completion: @escaping ((String) -> Void)) {
        let isHighImportance = item.importance == .high
        importanceIconView.isHidden = !isHighImportance
        let image = isHighImportance ? YandexImage.radioButtonHighImportance.image : YandexImage.radioButtonOff.image

        noteLabel.attributedText = item.text.withStrike()
        
        if let deadline = item.deadline {
            deadlineLabel.text = DateFormatter.format(date: deadline, dateFormat: "dd MMMM")
            deadlineView.isHidden = false
        }

        self.item = item
        self.buttonPressedHandler = completion
        
        if item.isCompleted {
            radioButtonPressed(radioButton)
        }
    }
    
    @objc private func radioButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        noteLabel.textColor = sender.isSelected ? YandexColor.labelTertiary.color : YandexColor.labelPrimary.color
        
        guard let item else { return }
        noteLabel.attributedText = item.text.withStrike(sender.isSelected)
        
        if item.importance == .high {
            importanceIconView.isHidden.toggle()
        }
        
        if item.deadline != nil {
            deadlineView.isHidden.toggle()
            print(deadlineView.isHidden)
        }
        
        
        buttonPressedHandler?(item.id)
        delegate?.updateItem(item)
    }
    
    override func prepareForReuse() {
        deadlineLabel.text = nil
        noteLabel.attributedText = nil
        item = nil
        importanceIconView.isHidden = true
        deadlineView.isHidden = true
    }
    
}
