import UIKit

class MultipleAppCell: UICollectionViewCell {
    
    var app: FeedResult? {
        didSet {
            nameLabel.text = app?.name
            companyLabel.text = app?.artistName
            imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 15))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 12))
    
    let getBtn = UIButton(title: "GET")
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        nameLabel.numberOfLines = 2
        companyLabel.textColor = .gray
        
        getBtn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getBtn.constrainWidth(constant: 80)
        getBtn.constrainHeight(constant: 32)
        getBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getBtn.layer.cornerRadius = 32 / 2
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangeSubViews: [nameLabel, companyLabel]), getBtn])
        addSubview(stackView)
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.fillSuperview()
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -4, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

