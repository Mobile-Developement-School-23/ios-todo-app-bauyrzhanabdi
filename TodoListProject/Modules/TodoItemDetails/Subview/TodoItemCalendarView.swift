import SnapKit
import UIKit

// MARK: - TodoItemCalendarViewDelegate

protocol TodoItemCalendarViewDelegate: AnyObject {
    func todoItemCalendarView(_ view: TodoItemCalendarView, didChange date: Date)
}

// MARK: - TodoItemCalendarView

final class TodoItemCalendarView: UIView {
    weak var delegate: TodoItemCalendarViewDelegate?

    var selectedDate: Date? {
        didSet {
            guard let selectedDate else {
                return
            }

            let components = makeDateComponents(from: selectedDate)
            calendarSelectionBehavior.selectedDate = components
            calendarView.selectionBehavior = calendarSelectionBehavior
        }
    }

    private(set) lazy var calendarSelectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    private(set) lazy var calendarView = makeCalendarView()
    private lazy var dividerView = DividerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func setup() {
        [calendarView, dividerView].forEach { addSubview($0) }

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = DSColor.backSecondary.color
    }

    private func setupConstraints() {
        calendarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.size.equalTo(320)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    private func makeCalendarView() -> UICalendarView {
        let calendarView = UICalendarView()
//        calendarView.availableDateRange = DateInterval(
//            start: .now,
//            end: Date.distantFuture
//        )
        calendarView.calendar = CalendarProvider.calendar
        return calendarView
    }

    private func makeDateComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: date
        )
        return dateComponents
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension TodoItemCalendarView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard
            let dateComponents,
            let date = dateComponents.date
        else {
            return
        }

        delegate?.todoItemCalendarView(self, didChange: date)
    }
}
