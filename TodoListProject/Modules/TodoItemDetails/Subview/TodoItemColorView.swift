import SnapKit
import UIKit

// MARK: - TodoItemColorViewDelegate

protocol TodoItemColorViewDelegate: AnyObject {
    func todoItemColorView(_ view: TodoItemColorView, didSelect color: UIColor?)
}

// MARK: - TodoItemColorView

final class TodoItemColorView: UIView {
    weak var delegate: TodoItemColorViewDelegate?

    var selectedColor: UIColor? {
        didSet {
            guard selectedColor != oldValue else {
                return
            }

            colorIndicatorView.backgroundColor = selectedColor
            hexColorLabel.text = selectedColor?.hex
            opacitySlider.value = Float(selectedColor?.cgColor.alpha ?? 1)
        }
    }

    private var alphaComponent: CGFloat?

    private lazy var colorIndicatorView = makeInidcatorView()
    private lazy var hexColorLabel = makeHexColorLabel()
    private lazy var spectrumView = makeSpectrumView()
    private lazy var opacitySlider = makeOpacitySlider()

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    @objc
    private func didChangeOpacitySlider(_ sender: OpacitySlider) {
        alphaComponent = CGFloat(sender.value)

        guard let selectedColor else {
            return
        }

        self.selectedColor = selectedColor.withAlphaComponent(
            CGFloat(sender.value)
        )

        delegate?.todoItemColorView(self, didSelect: selectedColor)
    }

    private func setup() {
        [
            colorIndicatorView,
            hexColorLabel,
            spectrumView,
            opacitySlider
        ].forEach { addSubview($0) }

        setupConstraints()
    }

    private func setupConstraints() {
        colorIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(32)
        }
        hexColorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorIndicatorView)
            make.leading.equalTo(colorIndicatorView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        spectrumView.snp.makeConstraints { make in
            make.top.equalTo(colorIndicatorView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        opacitySlider.snp.makeConstraints { make in
            make.top.equalTo(spectrumView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func makeInidcatorView() -> UIView {
        let view = UIView()
        view.layer.borderColor = DSColor.supportSeparator.color.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 16
        return view
    }

    private func makeHexColorLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.headline.font
        label.text = "#HEX"
        return label
    }

    private func makeSpectrumView() -> SpectrumView {
        let view = SpectrumView()
        view.delegate = self
        return view
    }

    private func makeOpacitySlider() -> OpacitySlider {
        let slider = OpacitySlider()
        slider.addTarget(
            self,
            action: #selector(didChangeOpacitySlider),
            for: .valueChanged
        )
        return slider
    }
}

// MARK: - SpectrumViewDelegate

extension TodoItemColorView: SpectrumViewDelegate {
    func spectrumView(_: SpectrumView, didSelect color: UIColor) {
        if let alphaComponent {
            selectedColor = color.withAlphaComponent(alphaComponent)
        } else {
            selectedColor = color
        }

        delegate?.todoItemColorView(self, didSelect: selectedColor)
    }
}
