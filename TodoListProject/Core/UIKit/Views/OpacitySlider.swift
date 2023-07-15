import UIKit

class OpacitySlider: UISlider {
    private lazy var gradientLayer = makeGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    private func setup() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 16
        minimumValue = 0
        maximumValue = 1
        value = 1

        setupColors()
    }

    private func setupColors() {
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
    }

    private func makeGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.frame = bounds
        return layer
    }
}
