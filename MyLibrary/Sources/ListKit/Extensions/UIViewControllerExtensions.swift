import UIKit

extension UIViewController {
    public func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideOfKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func didTapOutsideOfKeyboard() {
        view.endEditing(true)
    }
}
