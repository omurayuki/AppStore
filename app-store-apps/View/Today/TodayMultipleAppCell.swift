import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem? {
        didSet {
            categoryLabel.text = todayItem?.category
            titleLabel.text = todayItem?.title
            multipleAppsViewController.apps = todayItem?.app ?? []
            multipleAppsViewController.collectionView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 29), numberOfLines: 0)
    
    let multipleAppsViewController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        
        let stackView = VerticalStackView(arrangeSubViews: [
            categoryLabel, titleLabel, multipleAppsViewController.view
            ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
