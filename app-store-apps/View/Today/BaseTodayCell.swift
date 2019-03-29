import UIKit

class BaseTodayCell: UICollectionViewCell {
    
    var todayItem: TodayItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
