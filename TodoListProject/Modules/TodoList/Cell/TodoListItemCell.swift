import SnapKit
import UIKit

protocol TodoListItemCellDelegate: AnyObject {
    func todoListItemCell(_ cell: TodoListItemCell, didSelectRadioButton isSelected: Bool)
}

final class TodoListItemCell: UITableViewCell {
    weak var delegate: TodoListItemCellDelegate?

    private lazy var radioButton = makeRadioButton()
    private lazy var verticalStackView = makeVerticalStackView()
    private lazy var titleStackView = makeTitleStackView()
    private lazy var highPriorityImageView = UIImageView(image: DSImage.priorityHigh.image)
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleStackView = makeSubtitleStackView()
    private lazy var calendarImageView = makeCalendarImageView()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var chevronImageView = UIImageView(image: DSImage.chevron.image)
    private lazy var dividerView = DividerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    @objc
    private func didSelectButton(_ sender: UIButton) {
        sender.isSelected.toggle()

        delegate?.todoListItemCell(self, didSelectRadioButton: sender.isSelected)
    }

    func configure(with viewModel: TodoItemCellViewModel) {
        radioButton.isSelected = viewModel.isCompleted
        radioButton.setImage(viewModel.radioButtonNormalImage, for: .normal)
        highPriorityImageView.isHidden = viewModel.isHiddenHighPriorityImageView
        titleLabel.attributedText = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        subtitleStackView.isHidden = viewModel.isHiddenSubtitle
        subtitleLabel.text = viewModel.subtitle
    }

    private func setup() {
        [
            radioButton,
            verticalStackView,
            chevronImageView,
            dividerView
        ].forEach { contentView.addSubview($0) }

        selectionStyle = .none

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = .clear
        titleLabel.textColor = DSColor.labelPrimary.color
        calendarImageView.tintColor = DSColor.labelTertiary.color
    }

    private func setupConstraints() {
        radioButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(radioButton.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
        highPriorityImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16, height: 20))
        }
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(verticalStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(titleStackView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    private func makeRadioButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = DSColor.supportSeparator.color.cgColor
        button.layer.cornerRadius = 12
        button.setImage(DSImage.radioButtonOn.image, for: .selected)
        return button
    }

    private func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, subtitleStackView])
        stackView.axis = .vertical
        return stackView
    }

    private func makeTitleStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [highPriorityImageView, titleLabel])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        label.numberOfLines = 3
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }

    private func makeSubtitleStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [calendarImageView, subtitleLabel])
        stackView.spacing = 2
        return stackView
    }

    private func makeCalendarImageView() -> UIImageView {
        let imageView = UIImageView(image: DSImage.calendar.image)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }

    private func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.subhead.font
        label.textColor = DSColor.labelTertiary.color
        return label
    }
}
