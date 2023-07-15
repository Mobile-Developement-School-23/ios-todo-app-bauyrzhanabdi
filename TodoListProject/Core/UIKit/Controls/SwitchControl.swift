import SnapKit
import UIKit

final class SwitchControl: UIControl {
    override var isSelected: Bool {
        didSet {
            configureSubviews()
        }
    }

    var title: String? {
        didSet {
            guard let title, title != oldValue else {
                return
            }

            titleLabel.text = title
        }
    }

    var isHiddenSubtitle = false {
        didSet {
            subtitleLabel.isHidden = isHiddenSubtitle
        }
    }

    var subtitleColor: UIColor? {
        didSet {
            guard let subtitleColor, subtitleColor != oldValue else {
                return
            }

            subtitleLabel.textColor = subtitleColor
        }
    }

    var subtitle: String? {
        didSet {
            guard let subtitle, subtitle != oldValue else {
                return
            }

            subtitleLabel.text = subtitle
        }
    }

    var isHiddenDividerByDefault: Bool? {
        didSet {
            guard let isHiddenDividerByDefault, isHiddenDividerByDefault != oldValue else {
                return
            }

            dividerView.isHidden = isHiddenDividerByDefault
        }
    }

    private lazy var stackView = makeVerticalStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var switchControl = makeSwitch()
    private lazy var dividerView = DividerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func configureSubviews() {
        subtitleLabel.isHidden = !isSelected
        switchControl.isOn = isSelected
        switchControl.tintColor = isSelected
            ? DSColor.colorGreen.color
            : DSColor.supportOverlay.color
        if isHiddenDividerByDefault == nil {
            dividerView.isHidden = !isSelected
        }
    }

    private func setup() {
        [
            stackView,
            switchControl,
            dividerView
        ].forEach { addSubview($0) }

        configureSubviews()
        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        titleLabel.textColor = DSColor.labelPrimary.color
        subtitleLabel.textColor = DSColor.colorBlue.color
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        switchControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(stackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(
                CGSize(width: 52, height: 32)
            )
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    private func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, subtitleLabel]
        )
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        return stackView
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        return label
    }

    private func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.footnote.font
        return label
    }

    private func makeSwitch() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.isUserInteractionEnabled = false
        return switchControl
    }
}
