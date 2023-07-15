import SnapKit
import UIKit

final class DeleteControl: UIControl {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 56)
    }

    override var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else {
                return
            }

            titleLabel.textColor = isEnabled ? DSColor.colorRed.color : DSColor.labelTertiary.color
        }
    }

    private lazy var titleLabel = makeTitleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func setup() {
        addSubview(titleLabel)

        layer.cornerRadius = 16

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = DSColor.backSecondary.color
        titleLabel.textColor = DSColor.colorRed.color
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        label.text = "Удалить" // TODO: - Localize
        label.textAlignment = .center
        return label
    }
}
