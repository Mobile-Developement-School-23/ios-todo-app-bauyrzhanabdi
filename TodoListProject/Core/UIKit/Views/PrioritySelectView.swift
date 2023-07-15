import ListKit
import SnapKit
import UIKit

// MARK: - PrioritySelectViewDelegate

protocol PrioritySelectViewDelegate: AnyObject {
    func didSelectPriority(_ priority: TodoItem.Importance)
}

// MARK: - PrioritySelectView

final class PrioritySelectView: UIView {
    weak var delegate: PrioritySelectViewDelegate?

    private lazy var stackView = UIStackView(arrangedSubviews: controls)

    private lazy var controls = TodoItem.Importance.allCases.map {
        let control = PriorityControl(priority: $0)
        control.addTarget(self, action: #selector(didTapControl), for: .touchUpInside)
        return control
    }

    var selectedPriority: TodoItem.Importance = .basic {
        didSet {
            guard
                selectedPriority != oldValue
            else {
                return
            }

            configureControls()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    @objc
    private func didTapControl(_ sender: PriorityControl) {
        selectedPriority = sender.priority
        delegate?.didSelectPriority(selectedPriority)
    }

    private func setup() {
        addSubview(stackView)
        layer.cornerRadius = 8

        configureControls()
        setupColors()
        setupConstraints()
    }

    private func configureControls() {
        controls.forEach {
            $0.isHiddenDivider = false
        }

        controls.forEach {
            $0.isSelected = ($0.priority == selectedPriority)
            $0.isHiddenDivider = ($0.priority == selectedPriority)
        }

        guard
            let index = TodoItem.Importance.allCases.firstIndex(of: selectedPriority),
            index > 0
        else {
            return
        }

        controls[index - 1].isHiddenDivider = true
    }

    private func setupColors() {
        backgroundColor = DSColor.supportOverlay.color
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(
                UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            )
        }
    }
}
