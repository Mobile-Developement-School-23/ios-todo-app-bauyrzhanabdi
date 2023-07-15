import SnapKit
import UIKit

// MARK: - ColorSliderViewDelegate

protocol ColorSliderViewDelegate: AnyObject {
    func colorSliderView(_ view: ColorSliderView, didChange value: Int)
}

// MARK: - ColorSliderView

final class ColorSliderView: UIView {
    enum Color {
        case red
        case green
        case blue
    }

    weak var delegate: ColorSliderViewDelegate?

    var value: Int = 0 {
        didSet {
            configureSubviews(for: value)
            delegate?.colorSliderView(self, didChange: value)
        }
    }

    private lazy var slider = makeSlider()
    private lazy var textFieldContainerView = makeTextFieldContainerView()
    private lazy var textField = makeTextField()

    private(set) var color: Color

    init(color: Color) {
        self.color = color
        super.init(frame: .zero)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    func setValue(_ value: Int) {
        configureSubviews(for: value)
    }

    @objc
    private func didChangeSlider(_ slider: UISlider) {
        value = Int(slider.value)
    }

    private func configureSubviews(for value: Int) {
        slider.value = Float(value)
        textField.text = value.description
    }

    private func setup() {
        [slider, textFieldContainerView].forEach { addSubview($0) }

        configureSubviews(for: value)
        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        textFieldContainerView.backgroundColor = DSColor.supportOverlay.color
        textField.textColor = DSColor.labelPrimary.color

        switch color {
        case .red:
            slider.tintColor = DSColor.colorRed.color
        case .green:
            slider.tintColor = DSColor.colorGreen.color
        case .blue:
            slider.tintColor = DSColor.colorBlue.color
        }
        slider.maximumTrackTintColor = DSColor.supportOverlay.color
    }

    private func setupConstraints() {
        slider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(32)
        }
        textFieldContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(slider.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(
                CGSize(width: 48, height: 32)
            )
        }
        textField.snp.makeConstraints { make in
            make.edges.equalTo(
                UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            )
        }
    }

    private func makeSlider() -> UISlider {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(didChangeSlider), for: .valueChanged)
        slider.maximumValue = 255
        slider.minimumValue = 0
        slider.isContinuous = true
        return slider
    }

    private func makeTextFieldContainerView() -> UIView {
        let view = UIView()
        view.addSubview(textField)
        view.layer.cornerRadius = 8
        return view
    }

    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.font = DSFont.body.font
        textField.keyboardType = .numberPad
        textField.text = "0"
        textField.textAlignment = .center
        return textField
    }
}

// MARK: - UITextFieldDelegate

extension ColorSliderView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        let selectedValue = Int(text) ?? 0
        value = selectedValue >= 255 ? 255 : selectedValue
        textField.text = value.description
    }
}
