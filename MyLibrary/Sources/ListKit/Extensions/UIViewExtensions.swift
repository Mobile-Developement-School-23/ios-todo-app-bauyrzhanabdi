import UIKit

public extension UIView {
    func addShadow(
        offset: CGSize = CGSize.zero,
        color: UIColor = UIColor.gray,
        radius: CGFloat = 4.0,
        opacity: Float = 0.2
    ) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}
