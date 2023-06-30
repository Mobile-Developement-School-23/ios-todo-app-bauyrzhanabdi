import UIKit

final class NoteTextView: UITextView {
    
    // MARK: - Constants
    private enum Constants {
        static let offset: CGFloat = 16
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        font = YandexFont.body.font
        textColor = YandexColor.labelTertiary.color
        textContainerInset = UIEdgeInsets(top: Constants.offset, left: Constants.offset, bottom: Constants.offset, right: Constants.offset)
        layer.cornerRadius = Constants.cornerRadius
        autocorrectionType = .no
        isScrollEnabled = false
        text = "Что надо сделать?"
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.width = size.width
        return newSize
    }
}
