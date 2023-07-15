import ListKit
import SnapKit
import UIKit

// MARK: - TodoItemDetailsViewDelegate

protocol TodoItemDetailsViewDelegate: AnyObject {
    func didSelectPriority(_ priority: TodoItem.Importance)
    func didSelectDeadline(_ date: Date?)
    func didSelectColor(_ color: UIColor?)
}

// MARK: - TodoItemDetailsView

final class TodoItemDetailsView: UIView {
    weak var delegate: TodoItemDetailsViewDelegate?

    private lazy var stackView = makeStackView()
    private lazy var priorityView = makePriorityView()
    private lazy var deadlineControl = makeDeadlineSwitchControl()
    private lazy var calendarView = makeCalendarView()
    private lazy var colorSwitchControl = makeColorSwitchControl()
    private lazy var colorView = makeColorPickerView()

    private var deadlineFallback: Date {
        return CalendarProvider.calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) ?? Date()
    }

    private let item: TodoItem?

    init(item: TodoItem?) {
        self.item = item
        super.init(frame: .zero)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    @objc
    private func didTapDeadlineControl(_ sender: SwitchControl) {
        sender.isSelected.toggle()
        deadlineControl.subtitle = sender.isSelected
            ? DateFormatterProvider.dateFormatter.string(from: deadlineFallback)
            : nil
        calendarView.selectedDate = sender.isSelected ? deadlineFallback : nil
        calendarView.isHidden = !sender.isSelected

        delegate?.didSelectDeadline(sender.isSelected ? deadlineFallback : nil)
    }

    @objc
    private func didTapColorControl(_ sender: SwitchControl) {
        sender.isSelected.toggle()

        colorView.isHidden = !sender.isSelected

        if !sender.isSelected {
            delegate?.didSelectColor(nil)
        }
    }

    private func setup() {
        addSubview(stackView)
        layer.cornerRadius = 16

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = DSColor.backSecondary.color
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                priorityView,
                deadlineControl,
                calendarView,
                colorSwitchControl,
                colorView
            ]
        )
        stackView.axis = .vertical
        return stackView
    }

    private func makePriorityView() -> UIView {
        let view = TodoItemPriorityView(priority: item?.importance)
        view.delegate = self
        return view
    }

    private func makeDeadlineSwitchControl() -> SwitchControl {
        let control = SwitchControl()
        control.addTarget(self, action: #selector(didTapDeadlineControl), for: .touchUpInside)
        control.isHiddenDividerByDefault = false
        control.title = "Сделать до" // TODO: - Localize
        control.isSelected = item?.deadline != nil
        return control
    }

    private func makeCalendarView() -> TodoItemCalendarView {
        let view = TodoItemCalendarView()
        view.delegate = self
        view.isHidden = item?.deadline == nil
        view.selectedDate = item?.deadline
        return view
    }

    private func makeColorSwitchControl() -> SwitchControl {
        let control = SwitchControl()
        control.addTarget(self, action: #selector(didTapColorControl), for: .touchUpInside)
        control.title = "Цвет" // TODO: - Localize
        control.isHiddenSubtitle = true
        control.isSelected = item?.color != nil
        return control
    }

    private func makeColorPickerView() -> TodoItemColorView {
        let view = TodoItemColorView()
        view.delegate = self
        view.isHidden = item?.color == nil

        if let color = item?.color {
            view.selectedColor = UIColor(hex: color)
        }

        return view
    }
}

// MARK: - TodoItemPriorityViewDelegate

extension TodoItemDetailsView: TodoItemPriorityViewDelegate {
    func didSelectPriority(_ priority: TodoItem.Importance) {
        delegate?.didSelectPriority(priority)
    }
}

// MARK: - TodoItemCalendarViewDelegate

extension TodoItemDetailsView: TodoItemCalendarViewDelegate {
    func todoItemCalendarView(_: TodoItemCalendarView, didChange date: Date) {
        deadlineControl.subtitle = DateFormatterProvider.dateFormatter.string(
            from: date
        )
        delegate?.didSelectDeadline(date)
    }
}

// MARK: - TodoItemColorViewDelegate

extension TodoItemDetailsView: TodoItemColorViewDelegate {
    func todoItemColorView(_: TodoItemColorView, didSelect color: UIColor?) {
        guard let color else {
            return
        }

        delegate?.didSelectColor(color)
    }
}
