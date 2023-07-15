import UIKit

public extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: "\(Cell.self)", for: indexPath) as? Cell else {
            fatalError("register(cellClass:) has not been implemented")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<View: UITableViewHeaderFooterView>() -> View {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: "\(View.self)") as? View else {
            fatalError("register(aClass:) has not been implemented")
        }

        return view
    }
}

public extension UITableView {
    func register(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: "\(cellClass)")
    }

    func register(aClass: AnyClass) {
        register(aClass, forHeaderFooterViewReuseIdentifier: "\(aClass)")
    }
}
