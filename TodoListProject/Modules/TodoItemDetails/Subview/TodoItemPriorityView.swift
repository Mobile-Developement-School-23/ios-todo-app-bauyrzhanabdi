import ListKit
import SnapKit
import UIKit

// MARK: - TodoItemPriorityViewDelegate

protocol TodoItemPriorityViewDelegate: AnyObject {
    func didSelectPriority(_ priority: TodoItem.Importance)
}

// MARK: - TodoItemPriorityView

final class TodoItemPriorityView: UIView {
    weak var delegate: TodoItemPriorityViewDelegate?

    private lazy var titleLabel = makeTitleLabel()
    private lazy var prioritySelectView = makePrioritySelectView()
    private lazy var dividerView = DividerView()

    private let priority: TodoItem.Importance?

    init(priority: TodoItem.Importance? = nil) {
        self.priority = priority
        super.init(frame: .zero)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func setup() {
        [
            titleLabel,
            prioritySelectView,
            dividerView
        ].forEach { addSubview($0) }

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        titleLabel.textColor = DSColor.labelPrimary.color
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        prioritySelectView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-12)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    private func makePrioritySelectView() -> PrioritySelectView {
        let view = PrioritySelectView()
        view.delegate = self

        if let priority {
            view.selectedPriority = priority
        }

        return view
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        label.text = "Важность" // TODO: - Localize
        return label
    }
}

// MARK: - PrioritySelectViewDelegate

extension TodoItemPriorityView: PrioritySelectViewDelegate {
    func didSelectPriority(_ priority: TodoItem.Importance) {
        delegate?.didSelectPriority(priority)
    }
}
