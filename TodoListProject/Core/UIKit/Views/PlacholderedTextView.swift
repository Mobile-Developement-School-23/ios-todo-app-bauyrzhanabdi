import UIKit

final class PlacholderedTextView: UITextView {
    var isPlaceHoldered = true {
        didSet {
            guard isPlaceHoldered != oldValue else {
                return
            }

            configurePlaceholder()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        configurePlaceholder()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func configurePlaceholder() {
        if isPlaceHoldered {
            text = "Что надо сделать?" // TODO: - Localize
            textColor = DSColor.labelTertiary.color
        } else {
            text = ""
            textColor = DSColor.labelPrimary.color
        }
    }
}
