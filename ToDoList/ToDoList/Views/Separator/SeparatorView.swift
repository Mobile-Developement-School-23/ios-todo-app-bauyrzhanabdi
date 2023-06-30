import UIKit

final class SeparatorView: UIView {
        
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
        backgroundColor = YandexColor.supportSeparator.color
        translatesAutoresizingMaskIntoConstraints = false
    }
}
