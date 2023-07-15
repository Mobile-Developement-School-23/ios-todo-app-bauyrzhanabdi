import ListKit
import UIKit

// MARK: - TodoListTableViewDelegateImpl

final class TodoListTableViewDelegateImpl: NSObject {
    weak var tableView: UITableView?

    var didSelectRowAt: ((IndexPath) -> Void)?
    var didCompleteItemAt: ((IndexPath) -> Void)?
    var didTapEditItem: ((TodoItem) -> Void)?
    var didDeleteItemAt: ((IndexPath) -> Void)?
    var didSetSelectedItemAt: ((Bool, IndexPath) -> Void)?

    var rows: [TodoItemRow] = []
}

// MARK: - UITableViewDelegate

extension TodoListTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt?(indexPath)
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        switch cell {
        case let cell as TodoListItemCell:
            cell.delegate = self
        default:
            return
        }
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        switch rows[indexPath.row] {
        case let .item(item):
            guard !item.done else {
                return nil
            }

            let completeAction = UIContextualAction(
                style: .normal,
                title: nil,
                handler: { [weak self] _, _, completionHandler in
                    guard let self else {
                        return
                    }

                    completionHandler(true)
                    self.didCompleteItemAt?(indexPath)
                }
            )

            completeAction.image = UIImage(systemName: "checkmark.circle.fill")
            completeAction.backgroundColor = DSColor.colorGreen.color

            return UISwipeActionsConfiguration(actions: [completeAction])
        default:
            return nil
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        switch rows[indexPath.row] {
        case let .item(item):
            let openDetailsAction = UIContextualAction(
                style: .normal,
                title: nil,
                handler: { [weak self] _, _, completionHandler in
                    guard let self else {
                        return
                    }

                    completionHandler(true)
                    didTapEditItem?(item)
                }
            )

            openDetailsAction.image = UIImage(systemName: "info.circle.fill")
            openDetailsAction.backgroundColor = DSColor.colorGrayLight.color

            let deleteAction = UIContextualAction(
                style: .normal,
                title: nil,
                handler: { [weak self] _, _, completionHandler in
                    completionHandler(true)
                    self?.didDeleteItemAt?(indexPath)
                }
            )

            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = DSColor.colorRed.color

            return UISwipeActionsConfiguration(actions: [deleteAction, openDetailsAction])
        default:
            return nil
        }
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point _: CGPoint
    ) -> UIContextMenuConfiguration? {
        switch rows[indexPath.row] {
        case let .item(item):
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
                guard let self else {
                    return nil
                }

                let complete = UIAction(
                    title: "Выполнить", // TODO: - Localize
                    image: UIImage(systemName: "checkmark")
                ) { _ in
                    self.didCompleteItemAt?(indexPath)
                }

                let edit = UIAction(
                    title: "Править", // TODO: - Localize
                    image: UIImage(systemName: "square.and.pencil")
                ) { _ in

                    self.didTapEditItem?(item)
                }

                let delete = UIAction(
                    title: "Удалить", // TODO: - Localize
                    image: UIImage(systemName: "trash")
                ) { _ in
                    self.didDeleteItemAt?(indexPath)
                }

                if item.done {
                    return UIMenu(title: "", children: [edit, delete])
                } else {
                    return UIMenu(title: "", children: [complete, edit, delete])
                }
            }
        default:
            return nil
        }
    }
}

// MARK: - TodoListItemCellDelegate

extension TodoListTableViewDelegateImpl: TodoListItemCellDelegate {
    func todoListItemCell(_ cell: TodoListItemCell, didSelectRadioButton isSelected: Bool) {
        guard let indexPath = tableView?.indexPath(for: cell) else {
            return
        }

        didSetSelectedItemAt?(isSelected, indexPath)
    }
}
