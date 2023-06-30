import UIKit

final class DeleteButton: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let newHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let newWidth = originalSize.width
        let newHeight = Constants.newHeight
        return CGSize(width: newWidth, height: newHeight)
    }
    
    // MARK: - Initialization
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = YandexColor.backSecondary.color
        setTitleColor(YandexColor.colorRed.color, for: .normal)
        titleLabel?.font = YandexFont.body.font
        contentHorizontalAlignment = .center
        layer.cornerRadius = Constants.cornerRadius
        setTitle("Удалить", for: .normal)
    }
    
    // MARK: - Methods
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        let attributes = [NSAttributedString.Key.font: YandexFont.body.font]
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
