import UIKit

class AppRowCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 15))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 12))
    
    let getBtn = UIButton(title: "GET")
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
