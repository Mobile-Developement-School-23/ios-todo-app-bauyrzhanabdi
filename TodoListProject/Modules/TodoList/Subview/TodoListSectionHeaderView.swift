import SkeletonView
import UIKit

protocol TodoListHeaderViewDelegate: AnyObject {
    func todoListHeaderView(
        _ view: TodoListHeaderView,
        didSelectShowButton isSelected: Bool
    )
}

final class TodoListHeaderView: UIView {
    weak var delegate: TodoListHeaderViewDelegate?

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private lazy var titleLabel = makeTitleLabel()
    private lazy var showButton = makeShowButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        nil
    }

    @objc
    private func didTapShowButton(_ sender: UIButton) {
        sender.isSelected.toggle()

        delegate?.todoListHeaderView(self, didSelectShowButton: sender.isSelected)
    }

    private func configureColors() {
        titleLabel.textColor = DSColor.labelTertiary.color
        showButton.setTitleColor(DSColor.colorBlue.color, for: .normal)
    }

    private func setup() {
        [titleLabel, showButton].forEach { addSubview($0) }

        isSkeletonable = true
        
        setupConstraints()
        configureColors()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-12)
        }
        showButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.subhead.font
        return label
    }

    private func makeShowButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapShowButton), for: .touchUpInside)
        button.isSelected = true
        button.isSkeletonable = true
        button.skeletonCornerRadius = 8
        button.setTitle("Показать", for: .normal) // TODO: - Localize
        button.setTitle("Cкрыть", for: .selected) // TODO: - Localize
        button.titleLabel?.font = DSFont.subhead.font
        return button
    }
}
