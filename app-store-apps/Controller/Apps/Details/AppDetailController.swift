import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var appId: String?
    
    init(appId: String) {
        self.appId = appId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    var app: Result?
    var reviews: Reviews?
    
    let detailCellId = "detailCellId"
    let previewCellId = "previewCellId"
    let reviewCellId = "reviewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(AppPreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
        navigationItem.largeTitleDisplayMode = .never
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, error) in
            let app = result?.results.first
            self.app = app
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
        let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=jp&cc=jp"
        Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, _) in
            self.reviews = reviews
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as? AppDetailCell else { return UICollectionViewCell() }
            cell.app = app
            return cell
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as? AppPreviewCell else { return UICollectionViewCell() }
            cell.horizontalController.app = app
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as? ReviewRowCell else { return UICollectionViewCell() }
            cell.reviewsController.reviews = reviews
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 280
        if indexPath.item == 0 {
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            return .init(width: view.frame.width, height: estimatedSize.height)
        } else if indexPath.item == 1 {
            height = 500
        } else {
            height = 280
        }
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
