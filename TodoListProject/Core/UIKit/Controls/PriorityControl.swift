import ListKit
import SnapKit
import UIKit

final class PriorityControl: UIControl {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 48, height: 32)
    }

    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else {
                return
            }

            backgroundColor = isSelected ? DSColor.backElevated.color : .clear
        }
    }

    var isHiddenDivider = false {
        didSet {
            guard
                let dividerView,
                isHiddenDivider != oldValue
            else {
                return
            }

            dividerView.isHidden = isHiddenDivider
        }
    }

    private lazy var contentView = makeContentView()
    private lazy var dividerView = makeDivierView()

    private(set) var priority: TodoItem.Importance

    init(priority: TodoItem.Importance) {
        self.priority = priority
        super.init(frame: .zero)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func setup() {
        addSubview(contentView)
        if let dividerView {
            addSubview(dividerView)
        }
        addShadow()

        layer.cornerRadius = 8

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = .clear
        if let dividerView {
            dividerView.backgroundColor = DSColor.supportSeparator.color
        }
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        if let dividerView {
            dividerView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-8)
                make.width.equalTo(0.25)
            }
        }
    }

    private func makeContentView() -> UIView {
        switch priority {
        case .low:
            let imageView = UIImageView(image: DSImage.priorityLow.image)
            return imageView
        case .basic:
            let label = UILabel()
            label.font = DSFont.subhead.font
            label.textColor = DSColor.labelPrimary.color
            label.text = "нет" // TODO: - Localize
            return label
        case .important:
            let imageView = UIImageView(image: DSImage.priorityHigh.image)
            return imageView
        }
    }

    private func makeDivierView() -> UIView? {
        guard priority != TodoItem.Importance.allCases.last else {
            return nil
        }

        return DividerView()
    }
}
