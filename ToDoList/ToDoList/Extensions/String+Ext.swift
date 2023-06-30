import UIKit

extension String {
    func withStrike(_ isSelected: Bool = false) -> NSAttributedString? {
        guard !self.isEmpty else { return nil }
        let attributes: [NSAttributedString.Key : Any]? = isSelected ? [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] : nil
        let attributedText = NSAttributedString(string: self,
                                                attributes: attributes)
        return attributedText
    }
}
