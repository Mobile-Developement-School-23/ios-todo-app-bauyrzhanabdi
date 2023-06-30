import UIKit

protocol CalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

final class CalendarView: UIView  {
    
    // MARK: - Constants
    
    private enum Constants {
        static let calendarViewTopOffset: CGFloat = 8
        static let calendarViewLeadingOffset: CGFloat = 16
        static let calendarViewTrailingOffset: CGFloat = 16
        static let calendarViewBottomOffset: CGFloat = 8
    }
    
    // MARK: - Outlets
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.iso8601Calendar
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    // MARK: - Properties
    
    weak var delegate: CalendarViewDelegate?
    private lazy var calendarSelectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        addSubview(calendarView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.calendarViewTopOffset),
            calendarView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.calendarViewLeadingOffset),
            calendarView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.calendarViewTrailingOffset),
            calendarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.calendarViewBottomOffset)
        ])
    }
    
    // MARK: - Methods
    
    
    
}

// MARK: - Delegate Extensions

extension CalendarView: OptionsViewCalendarDelegate {
    func didChangeSelectionBehavior(_ isSelected: Bool, _ deadline: Date) {
        calendarSelectionBehavior.selectedDate = isSelected ? DateComponents.defaultDate(deadline) : nil
        calendarView.selectionBehavior = calendarSelectionBehavior
    }
}

extension CalendarView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard
            let dateComponents = dateComponents,
            let selectedDate = dateComponents.date
        else {
            return
        }
        
        delegate?.didSelectDate(selectedDate)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        guard
            let dateComponents = dateComponents,
            let selectedDate = dateComponents.date
        else {
            return false
        }
        
        let currentDate = Date()
        
        return selectedDate > currentDate
    }
}
