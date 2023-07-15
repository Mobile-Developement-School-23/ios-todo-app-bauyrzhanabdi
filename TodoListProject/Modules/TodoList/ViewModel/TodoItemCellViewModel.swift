import ListKit
import UIKit

struct TodoItemCellViewModel {
    var isCompleted: Bool {
        item.done
    }

    var radioButtonNormalImage: UIImage {
        if item.importance == .important {
            return DSImage.radioButtonHighPriority.image
        } else {
            return DSImage.radioButtonOff.image
        }
    }

    var isHiddenHighPriorityImageView: Bool {
        !(item.importance == .important)
    }

    var title: NSAttributedString {
        if item.done {
            return strikethroughText(item.text)
        } else {
            return NSAttributedString(string: item.text)
        }
    }

    var titleColor: UIColor? {
        guard !item.done else {
            return DSColor.labelTertiary.color
        }

        guard let color = item.color else {
            return DSColor.labelPrimary.color
        }

        return UIColor(hex: color)
    }

    var isHiddenSubtitle: Bool {
        item.deadline == nil
    }

    var subtitle: String? {
        guard let deadline = item.deadline else {
            return nil
        }

        let formatter = DateFormatterProvider.dateFormatter
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: deadline)
    }

    private let item: TodoItem

    init(item: TodoItem) {
        self.item = item
    }

    private func strikethroughText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length) // swiftlint:disable:this legacy_constructor
        )
        return attributedString
    }
}
