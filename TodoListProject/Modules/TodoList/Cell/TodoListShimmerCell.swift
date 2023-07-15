import SkeletonView
import SnapKit
import UIKit

final class TodoListShimmerCell: UITableViewCell {
    private lazy var imageSkeletonView = SkeletonableView(skeletonCornerRadius: 12)
    private lazy var titleView = SkeletonableView(skeletonCornerRadius: 8)
    private lazy var dividerView = DividerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setup() {
        [
            imageSkeletonView,
            titleView,
            dividerView
        ].forEach { contentView.addSubview($0) }
        
        backgroundColor = .clear
        isSkeletonable = true
        selectionStyle = .none
        contentView.isSkeletonable = true
        
        setupConstraints()
    }

    private func setupConstraints() {
        imageSkeletonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(24)
        }
        titleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageSkeletonView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(titleView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
