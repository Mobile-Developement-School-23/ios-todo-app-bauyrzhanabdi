import UIKit

final class DividerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = DSColor.supportSeparator.color
    }

    required init?(coder _: NSCoder) {
        nil
    }
}
