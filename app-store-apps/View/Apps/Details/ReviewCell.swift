import UIKit

class ReviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    
    let authorLabel = UILabel(text: "Author", font: .boldSystemFont(ofSize: 16))
    
    let starsLabel = UILabel(text: "Starts", font: .systemFont(ofSize: 14))
    
    let starsStackView: UIStackView = {
        var arrangedSubViews = [UIView]()
        (0 ..< 5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangedSubViews.append(imageView)
        }
        arrangedSubViews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        return stackView
    }()
    
    let bodyLabel = UILabel(text: "review body\nreview body\nreview body\nreview body\nreview body\nreview body\n", font: .systemFont(ofSize: 18), numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9003212246, green: 0.9003212246, blue: 0.9003212246, alpha: 0.6000000238)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangeSubViews: [
            UIStackView(arrangedSubviews: [
                titleLabel,
                authorLabel
                ], customSpacing: 8),
            starsStackView,
            bodyLabel
        ], spacing: 12)
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
