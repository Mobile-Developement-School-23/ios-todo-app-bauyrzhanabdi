import CocoaLumberjackSwift
import ListKit
import SnapKit
import SkeletonView
import UIKit

// MARK: - TodoListOutput

protocol TodoListOutput: AnyObject {
    var didTapAddItem: (() -> Void)? { get set }
    var didTapEditItem: ((TodoItem) -> Void)? { get set }
}

// MARK: - TodoListViewController

final class TodoListViewController: UIViewController, TodoListOutput {
    var didTapAddItem: (() -> Void)?
    var didTapEditItem: ((TodoItem) -> Void)?

    var isShownFullList = true {
        didSet {
            guard isShownFullList != oldValue else {
                return
            }

            configureRows()
        }
    }

    private lazy var scrollView = makeScrollView()
    private lazy var headerView = makeHeaderView()
    private lazy var tableView = makeTableView()
    private lazy var addButton = makeAddButton()

    private var items: [TodoItem] = [] {
        didSet {
            guard items != oldValue else {
                return
            }
            
            configureHeader()
            configureRows()
        }
    }

    private var rows: [TodoItemRow] = [] {
        didSet {
            tableViewDataSource.rows = rows
            tableViewDelegate.rows = rows
        }
    }

    private let tableViewDataSource = TodoListTableViewDataSourceImpl()
    private let tableViewDelegate = TodoListTableViewDelegateImpl()

    private let fileCache: FileCacheProvider

    init(
        fileCache: FileCacheProvider
    ) {
        self.fileCache = fileCache
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        nil
    }

    deinit {
        fileCache.removeObserver(self)
        DDLogWarn("FileCache observer removed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureRows()
        configureTableViewDelegate()
        setupObservers()
        setup()
        getTodoItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    @objc
    private func didTapAddButton(_: UIButton) {
        didTapAddItem?()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: DSColor.labelPrimary.color
        ]
        navigationItem.title = "Мои дела" // TODO: - Localize

        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.backgroundColor = DSColor.supportNavBarBlur.color
        compactAppearance.titleTextAttributes = [.font: DSFont.headline.font]
        navigationController?.navigationBar.standardAppearance = compactAppearance
        navigationController?.navigationBar.compactAppearance = compactAppearance

        let largeAppearance = UINavigationBarAppearance()
        largeAppearance.backgroundColor = DSColor.backIOSPrimary.color
        largeAppearance.largeTitleTextAttributes = [.font: DSFont.largeTitle.font]
        largeAppearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = largeAppearance
    }
    
    private func configureHeader() {
        headerView.title = "Выполнено — \(items.filter { $0.done }.count)"
    }

    private func configureRows() {
        if isShownFullList {
            rows = [
                items.map { TodoItemRow.item($0) },
                [TodoItemRow.addItem]
            ].flatMap { $0 }
        } else {
            rows = [
                items.filter { !$0.done }.map { TodoItemRow.item($0) },
                [TodoItemRow.addItem]
            ].flatMap { $0 }
        }

        tableView.reloadData()
    }
    
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    private func configureTableViewDelegate() {
        tableViewDelegate.tableView = tableView

        tableViewDelegate.didSelectRowAt = { [weak self] indexPath in
            guard let self else {
                return
            }

            switch self.rows[indexPath.row] {
            case let .item(item):
                self.didTapEditItem?(item)
            case .addItem:
                self.didTapAddItem?()
            }
        }
        tableViewDelegate.didCompleteItemAt = { [weak self] indexPath in
            guard let self else {
                return
            }

            switch self.rows[indexPath.row] {
            case var .item(item):
                item.done = true
                showLoading()
                self.fileCache.updateItem(item: item).always {
                    self.hideLoading()
                }
                DDLogInfo("Completed item with ID(\(item.id))")
            default:
                return
            }
        }
        tableViewDelegate.didTapEditItem = { [weak self] item in
            self?.didTapEditItem?(item)
        }
        tableViewDelegate.didDeleteItemAt = { [weak self] indexPath in
            guard let self else {
                return
            }

            switch self.rows[indexPath.row] {
            case let .item(item):
                showLoading()
                self.fileCache.removeItem(with: item.id).always {
                    self.hideLoading()
                }
            default:
                return
            }
        }
        tableViewDelegate.didSetSelectedItemAt = { [weak self] isSelected, indexPath in
            guard let self else {
                return
            }

            switch rows[indexPath.row] {
            case var .item(item):
                item.done = isSelected
                showLoading()
                fileCache.updateItem(item: item).always {
                    self.hideLoading()
                }
                DDLogInfo("Completed item with ID(\(item.id))")
            default:
                return
            }
        }
    }

    private func setupObservers() {
        fileCache.addObserver(self)
        DDLogWarn("FileCache observer added")
    }

    private func setup() {
        [
            scrollView,
            addButton
        ].forEach { view.addSubview($0) }

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        view.backgroundColor = DSColor.backIOSPrimary.color
        tableView.backgroundColor = DSColor.backSecondary.color
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(-32)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.equalToSuperview().offset(-32)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func getTodoItems() {
        showLoading()
        fileCache.getItems().always { [weak self] in
            self?.hideLoading()
        }
    }
    
    private func showLoading() {
        scrollView.showAnimatedSkeleton()
        addButton.isEnabled = false
    }
    
    private func hideLoading() {
        scrollView.hideSkeleton()
        addButton.isEnabled = true
    }

    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        [
            headerView,
            tableView
        ].forEach { scrollView.addSubview($0) }
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.isSkeletonable = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }

    private func makeHeaderView() -> TodoListHeaderView {
        let view = TodoListHeaderView()
        view.delegate = self
        view.isSkeletonable = true
        return view
    }

    private func makeTableView() -> ContentSizedTableView {
        let tableView = ContentSizedTableView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.estimatedRowHeight = 56
        tableView.isSkeletonable = true
        tableView.layer.cornerRadius = 16

        [
            TodoListItemCell.self,
            TodoListAddItemCell.self,
            TodoListShimmerCell.self
        ].forEach { tableView.register(cellClass: $0) }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }

    private func makeAddButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.setImage(DSImage.addLarge.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}

// MARK: - FileCacheProviderObserver

extension TodoListViewController: FileCacheProviderObserver {
    func fileCacheProvider(_: FileCacheProvider, didChangeTodoItems items: [TodoItem]) {
        self.items = items
        tableView.reloadData()
    }
}

// MARK: - TodoListHeaderViewDelegate

extension TodoListViewController: TodoListHeaderViewDelegate {
    func todoListHeaderView(_: TodoListHeaderView, didSelectShowButton isSelected: Bool) {
        isShownFullList = isSelected
    }
}
