import UIKit

class AppDetailCell: UICollectionViewCell {
    
    var app: Result? {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceBtn.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    let appIconImageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 18), numberOfLines: 2)
    let priceBtn = UIButton(title: "$4.99")
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        priceBtn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        priceBtn.constrainHeight(constant: 32)
        priceBtn.constrainWidth(constant: 80)
        priceBtn.layer.cornerRadius = 32 / 2
        priceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        priceBtn.setTitleColor(.white, for: .normal)
        
        let stackView = VerticalStackView(arrangeSubViews: [
            UIStackView(arrangedSubviews: [
                appIconImageView,
                VerticalStackView(arrangeSubViews: [
                    nameLabel,
                    UIStackView(arrangedSubviews: [
                        priceBtn,
                        UIView()
                    ]),
                    UIView()
                ], spacing: 12)
                ], customSpacing: 20),
            whatsNewLabel,
            releaseNotesLabel
        ], spacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}
