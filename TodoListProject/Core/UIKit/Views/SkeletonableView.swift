import SkeletonView
import UIKit

public final class SkeletonableView: UIView {
    public init(skeletonCornerRadius: Float = 0) {
        super.init(frame: .zero)
        isSkeletonable = true
        self.skeletonCornerRadius = skeletonCornerRadius
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
