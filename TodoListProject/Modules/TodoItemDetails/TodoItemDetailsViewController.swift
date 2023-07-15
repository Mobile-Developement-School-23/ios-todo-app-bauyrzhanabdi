import CocoaLumberjackSwift
import ListKit
import SnapKit
import UIKit

// MARK: - TodoItemDetailsOutput

protocol TodoItemDetailsOutput: AnyObject {
    var didTapCancelButton: (() -> Void)? { get set }
    var didTapSaveButton: (() -> Void)? { get set }
    var didTapDeletButton: (() -> Void)? { get set }
}

// MARK: - TodoItemDetailsViewController

final class TodoItemDetailsViewController: UIViewController, TodoItemDetailsOutput {
    var didTapCancelButton: (() -> Void)?
    var didTapSaveButton: (() -> Void)?
    var didTapDeletButton: (() -> Void)?

    private lazy var navBarContainerView = makeNavBarContainerView()
    private lazy var leftBarButton = makeLeftBarButton()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var rightBarButton = makeRightBarButton()
    private lazy var scrollView = makeScrollView()
    private lazy var stackView = makeStackView()
    private lazy var placholderedTextView = makePlaceholderedTextView()
    private lazy var detailsView = makeDetailsView()
    private lazy var deleteButton = makeDeleteButton()
    
    private var itemDidChange = false

    private let state: TodoItemDetailsState
    private var item: TodoItem
    private let fileCache: FileCacheProvider

    init(
        state: TodoItemDetailsState,
        fileCache: FileCacheProvider
    ) {
        self.state = state
        
        switch state {
        case .addItem:
            self.item = TodoItem(text: "")
        case let .editItem(item):
            self.item = item
        }
        
        self.fileCache = fileCache
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboard()
        setupObservers()
        setup()
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let nsValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardSize = nsValue.cgRectValue
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0
        )
        scrollView.contentInset = contentInsets
    }

    @objc
    private func keyboardWillHide(notification _: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
    }

    @objc
    private func didTapBarButton(sender: UIButton) {
        sender.isSelected.toggle()
        switch sender {
        case leftBarButton:
            didTapCancelButton?()
        case rightBarButton:

            guard !item.text.isEmpty else {
                return
            }

            if itemDidChange {
                switch state {
                case .addItem:
                    fileCache.addItem(item: item)
                    DDLogInfo("Added item to FileCache with ID(\(item.id))")
                case .editItem:
                    fileCache.updateItem(item: item)
                    DDLogInfo("Updated item in FileCache with ID(\(item.id))")
                }
            }

            didTapSaveButton?()
        default:
            break
        }
    }

    @objc
    private func didTapDeleteButton() {
        fileCache.removeItem(with: item.id)
        DDLogInfo("Removed item from FileCache with ID(\(item.id))")
        didTapDeletButton?()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setup() {
        [
            navBarContainerView,
            scrollView
        ].forEach { view.addSubview($0) }

        view.keyboardLayoutGuide.followsUndockedKeyboard = true

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        view.backgroundColor = DSColor.backPrimary.color
        placholderedTextView.backgroundColor = DSColor.backSecondary.color
        titleLabel.textColor = DSColor.labelPrimary.color
        [leftBarButton, rightBarButton].forEach {
            $0.setTitleColor(DSColor.colorBlue.color, for: .normal)
        }
        rightBarButton.setTitleColor(DSColor.labelTertiary.color, for: .disabled)
    }

    private func setupConstraints() {
        navBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        leftBarButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        rightBarButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBarContainerView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(
                UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            )
            make.width.equalToSuperview().offset(-32)
        }
        placholderedTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(120)
        }
    }

    private func makeNavBarContainerView() -> UIView {
        let view = UIView()
        [
            leftBarButton,
            titleLabel,
            rightBarButton
        ].forEach { view.addSubview($0) }
        return view
    }

    private func makeLeftBarButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBarButton), for: .touchUpInside)
        button.setTitle("Отменить", for: .normal) // TODO: - Localize
        button.titleLabel?.font = DSFont.body.font
        return button
    }

    private func makeRightBarButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBarButton), for: .touchUpInside)
        button.isEnabled = (state != .addItem)
        button.setTitle("Сохранить", for: .normal) // TODO: - Localize
        button.titleLabel?.font = DSFont.body.font
        return button
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        label.textAlignment = .center
        label.text = "Дело" // TODO: - Localize
        return label
    }

    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                placholderedTextView,
                detailsView,
                deleteButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }

    private func makePlaceholderedTextView() -> PlacholderedTextView {
        let textView = PlacholderedTextView()
        textView.font = DSFont.body.font
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 16
        textView.textContainerInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )

        switch state {
        case .addItem:
            textView.isPlaceHoldered = true
        case let .editItem(item):
            textView.isPlaceHoldered = false
            textView.text = item.text
        }

        return textView
    }

    private func makeDetailsView() -> UIView {
        let view = TodoItemDetailsView(item: item)
        view.delegate = self
        return view
    }

    private func makeDeleteButton() -> UIControl {
        let button = DeleteControl()
        button.isEnabled = (state != .addItem)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }
}

// MARK: - TodoItemDetailsViewDelegate: UITextViewDelegate

extension TodoItemDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_: UITextView) {
        placholderedTextView.isPlaceHoldered = false
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !placholderedTextView.isPlaceHoldered else {
            rightBarButton.isEnabled = false
            return
        }

        rightBarButton.isEnabled = !textView.text.isEmpty

        item.text = textView.text
        itemDidChange = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placholderedTextView.isPlaceHoldered = textView.text.isEmpty
    }
}

// MARK: - TodoItemDetailsViewDelegate

extension TodoItemDetailsViewController: TodoItemDetailsViewDelegate {
    func didSelectPriority(_ priority: TodoItem.Importance) {
        item.importance = priority
        itemDidChange = true
    }

    func didSelectDeadline(_ date: Date?) {
        item.deadline = date
        itemDidChange = true
    }

    func didSelectColor(_ color: UIColor?) {
        item.color = color?.hex
        itemDidChange = true
    }
}
