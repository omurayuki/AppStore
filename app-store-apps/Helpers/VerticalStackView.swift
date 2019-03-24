import UIKit

class VerticalStackView: UIStackView {

    init(arrangeSubViews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangeSubViews.forEach { addArrangedSubview($0) }
        self.spacing = spacing
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
