import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let stackViewSpacing: CGFloat = 16
        static let stackViewLeadingOffset: CGFloat = 16
        static let stackViewTrailingOffset: CGFloat = 16
        static let stackViewWidthOffset: CGFloat = 32
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
        static let textViewHeight: CGFloat = 120
    }
    
    // MARK: - Outlets
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textView: NoteTextView = {
        let textView = NoteTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var optionsView: OptionsView = {
        let view = OptionsView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteButton: DeleteButton = {
        let button = DeleteButton()
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = YandexColor.backPrimary.color
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(optionsView)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.stackViewLeadingOffset),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.stackViewTrailingOffset),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Constants.stackViewWidthOffset),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textViewHeight)
        ])
    }
    
    // MARK: - Methods

    @objc private func deleteButtonPressed(_ sender: DeleteButton) {
        print("delete button pressed")
    }
    
}

// MARK: - Delegate Extensions

extension DetailsViewController: OptionsViewDelegate {
    func didSelectImportance(_ importance: ToDoItem.Importance) {
        print("selected importance: \(importance)")
    }
    
    func didSelectDeadline(_ date: Date?) {
        print("selected date \(date)")
    }
    
}

