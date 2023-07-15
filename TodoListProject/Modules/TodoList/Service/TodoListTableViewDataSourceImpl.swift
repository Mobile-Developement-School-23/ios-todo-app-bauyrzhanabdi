import ListKit
import SkeletonView
import UIKit

// MARK: - TodoListTableViewDataSourceImpl

final class TodoListTableViewDataSourceImpl: NSObject {
    var rows: [TodoItemRow] = []
}

// MARK: - TodoListTableViewDataSource

extension TodoListTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .item(item):
            let cell: TodoListItemCell = tableView.dequeueReusableCell(for: indexPath)

            cell.configure(
                with: TodoItemCellViewModel(item: item)
            )

            return cell
        case .addItem:
            let cell: TodoListAddItemCell = tableView.dequeueReusableCell(for: indexPath)

            return cell
        }
    }
}

// MARK: - SkeletonTableViewDataSource

extension TodoListTableViewDataSourceImpl: SkeletonTableViewDataSource {
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        "\(TodoListShimmerCell.self)"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
}

