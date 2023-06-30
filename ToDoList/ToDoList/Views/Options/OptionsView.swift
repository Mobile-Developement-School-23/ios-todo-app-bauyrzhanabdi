import UIKit

protocol OptionsViewDelegate: AnyObject {
    func didSelectImportance(_ importance: ToDoItem.Importance)
    func didSelectDeadline(_ date: Date?)
}

protocol OptionsViewCalendarDelegate: AnyObject {
    func didChangeSelectionBehavior(_ isSelected: Bool, _ deadline: Date)
}

final class OptionsView: UIStackView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Outlets
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var importanceView: ImportanceView = {
        let view = ImportanceView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deadlineView: DeadlineView = {
        let view = DeadlineView()
        view.addTarget(self, action: #selector(deadlinePressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.isHidden = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    weak var delegate: OptionsViewDelegate?
    private weak var calendarDelegate: OptionsViewCalendarDelegate?
    
    var defaultDeadline: Date {
        return Calendar.iso8601Calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) ?? Date()
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = YandexColor.backSecondary.color
        calendarDelegate = calendarView
    }
    
    private func setupHierarchy() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(calendarView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Methods
    
    @objc private func deadlinePressed(_ sender: DeadlineView) {
        sender.isSelected.toggle()
        deadlineView.deadline = sender.isSelected ? defaultDeadline : nil
        calendarDelegate?.didChangeSelectionBehavior(sender.isSelected, defaultDeadline)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.calendarView.isHidden = !sender.isSelected
        }
        
        delegate?.didSelectDeadline(sender.isSelected ? defaultDeadline : nil)
    }
}

// MARK: - Delegate Extensions

extension OptionsView: ImportanceViewDelegate {
    func didSelectImportance(_ importance: ToDoItem.Importance) {
        delegate?.didSelectImportance(importance)
    }
}

extension OptionsView: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        deadlineView.deadline = date
        delegate?.didSelectDeadline(date)
    }
}
