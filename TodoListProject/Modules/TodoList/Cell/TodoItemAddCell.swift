import UIKit

final class TodoListAddItemCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    private func setup() {
        contentView.addSubview(titleLabel)

        selectionStyle = .none

        setupColors()
        setupConstraints()
    }

    private func setupColors() {
        backgroundColor = .clear
        titleLabel.textColor = DSColor.labelTertiary.color
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(
                UIEdgeInsets(top: 16, left: 52, bottom: 16, right: 16)
            )
        }
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = DSFont.body.font
        label.text = "Новое" // TODO: - Localize
        return label
    }
}
