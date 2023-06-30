import UIKit

final class NotesViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let tableViewLeadingOffset: CGFloat = 16
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Outlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = YandexColor.backSecondary.color
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.register(NotesTableViewHeader.self, forHeaderFooterViewReuseIdentifier: NotesTableViewHeader.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties (Items below are for testing ONLY!)
    
    private var items: [String: ToDoItem] = [
        "1": ToDoItem(id: "1", text: "Купить яйца 10шт", importance: .high, isCompleted: false, createDate: Date()),
        "2": ToDoItem(id: "2", text: "Сделать домашнее задание Яндекса", importance: .high, deadline: .now, isCompleted: true, createDate: Date()),
        "3": ToDoItem(id: "3", text: "Сходить в кино на Человека Паука", importance: .low, isCompleted: false, createDate: Date()),
        "4": ToDoItem(id: "4", text: "Пробежать 5 км", importance: .high, deadline: .now, isCompleted: false, createDate: Date()),
        "5": ToDoItem(id: "5", text: "Решить все алгоритмические задачи", importance: .regular, deadline: .now, isCompleted: false, createDate: Date()),
        "6": ToDoItem(id: "6", text: "Написать эссе", importance: .regular, deadline: .now, isCompleted: false, createDate: Date())
    ]
    
    private var completedItems: Int = 0
    
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
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableViewLeadingOffset),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    
    
    
}

// MARK: - TableView Delegate & Datasource

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NotesTableViewHeader.identifier) as? NotesTableViewHeader else { return UITableViewHeaderFooterView() }
        header.showButtonHandler = { isSelected in
            print("isSelected: \(isSelected)")
        }
        header.completedItems = completedItems
        return header
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        let itemsArray = Array(items.values)
        cell.configure(with: itemsArray[indexPath.row]) { [weak self] id in
            guard let header = self?.tableView.headerView(forSection: indexPath.section) as? NotesTableViewHeader else { return }
            header.completedItems += self?.items[id]?.isCompleted == true ? 1 : -1
        }
        cell.delegate = self
        return cell
    }
}

extension NotesViewController: NotesTableViewCellDelegate {
    func updateItem(_ item: ToDoItem) {
        var toDoItem = ToDoItem(id: item.id,
                                text: item.text,
                                importance: item.importance,
                                deadline: item.deadline,
                                isCompleted: !item.isCompleted,
                                createDate: item.createDate)
        
        items[toDoItem.id] = toDoItem
    }
}
