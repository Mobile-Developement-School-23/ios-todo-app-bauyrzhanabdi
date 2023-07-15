import SnapKit
import UIKit

// MARK: - ColorPickerViewDelegate

protocol ColorPickerViewDelegate: AnyObject {
    func colorPickerView(_ view: ColorPickerView, didChangeColor color: UIColor?)
}

// MARK: - ColorPickerView

final class ColorPickerView: UIView {
    weak var delegate: ColorPickerViewDelegate?

    override var isHidden: Bool {
        didSet {
            guard isHidden != oldValue else {
                return
            }

            stackView.isHidden = isHidden
            [
                redSlider,
                greenSlider,
                blueSlider
            ].forEach { $0.isHidden = isHidden }
        }
    }

    var color: UIColor? {
        didSet {
            guard
                let color,
                color != oldValue
            else {
                return
            }

            configureSubviews(for: color)

            delegate?.colorPickerView(self, didChangeColor: color)
        }
    }

    private lazy var stackView = makeStackView()
    private lazy var redSlider = makeColorSliderView(for: .red)
    private lazy var greenSlider = makeColorSliderView(for: .green)
    private lazy var blueSlider = makeColorSliderView(for: .blue)

    private var redValue: Int = 0 {
        didSet {
            guard redValue != oldValue else {
                return
            }

            redSlider.setValue(redValue)
        }
    }

    private var greenValue: Int = 0 {
        didSet {
            guard greenValue != oldValue else {
                return
            }

            greenSlider.setValue(greenValue)
        }
    }

    private var blueValue: Int = 0 {
        didSet {
            guard blueValue != oldValue else {
                return
            }

            blueSlider.setValue(blueValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    func setColor(_ color: UIColor) {
        configureSubviews(for: color)
    }

    private func configureSubviews(for color: UIColor) {
        guard let components = color.cgColor.components else {
            return
        }

        redValue = Int(components[0] * 255.0)
        greenValue = Int(components[1] * 255.0)
        blueValue = Int(components[2] * 255.0)
    }

    private func setup() {
        addSubview(stackView)

        setupConstraints()
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(
                UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            )
        }
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [redSlider, greenSlider, blueSlider])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }

    private func makeColorSliderView(for color: ColorSliderView.Color) -> ColorSliderView {
        let slider = ColorSliderView(color: color)
        slider.delegate = self
        return slider
    }
}

// MARK: - ColorSliderViewDelegate

extension ColorPickerView: ColorSliderViewDelegate {
    func colorSliderView(_ view: ColorSliderView, didChange value: Int) {
        switch view {
        case redSlider:
            redValue = value
        case greenSlider:
            greenValue = value
        case blueSlider:
            blueValue = value
        default:
            break
        }

        let cgColor = CGColor(
            red: CGFloat(redValue) / CGFloat(255),
            green: CGFloat(greenValue) / CGFloat(255),
            blue: CGFloat(blueValue) / CGFloat(255),
            alpha: 1
        )

        color = UIColor(cgColor: cgColor)
    }
}
