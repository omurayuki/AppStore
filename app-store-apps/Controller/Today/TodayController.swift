import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var items = [TodayItem]()
    
    var topGrossingGroup: AppGroup?
    var gameGroup: AppGroup?
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .darkGray
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = #colorLiteral(red: 0.9003212246, green: 0.9003212246, blue: 0.9003212246, alpha: 0.6000000238)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            self.topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            self.topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, app: []),
                TodayItem(category: "Daily List", title: self.topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, app: self.topGrossingGroup?.feed.results ?? []),
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "holiday"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: #colorLiteral(red: 0.9857528806, green: 0.9669142365, blue: 0.7202112079, alpha: 1), cellType: .single, app: []),
            ]
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = items[indexPath.item].cellType
        switch cellType {
        case .single:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayItem.CellType.single.rawValue, for: indexPath) as? TodayCell else { return UICollectionViewCell() }
            cell.todayItem = items[indexPath.item]
            return cell
        case .multiple:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayItem.CellType.multiple.rawValue, for: indexPath) as? TodayMultipleAppCell else { return UICollectionViewCell() }
            cell.multipleAppsViewController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
            cell.todayItem = items[indexPath.item]
            return cell
        }
    }
    
    @objc
    func handleMultipleAppsTap(gesture: UITapGestureRecognizer) {
        
        let collectionView = gesture.view
        
        // figure out which cell were clicking into
        
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].app
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                present(BackEnableNavigationController(rootViewController: fullController), animated: true)
                return
            }
            
            superview = superview?.superview
        }
    }
    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    var appFullscreenController: AppFullscreenController?
    var fullscreenView: UIView?
    var topConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .multiple {
            let fullController = TodayMultipleAppsController(mode: .fullscreen)
            fullController.apps = self.items[indexPath.item].app
            present(BackEnableNavigationController(rootViewController: fullController), animated: true)
            return
        }
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.item]
        appFullscreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView ?? UIView())
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        self.appFullscreenController = appFullscreenController
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        //スタート地点
        fullscreenView?.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView?.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leftConstraint = fullscreenView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin
        .x)
        widthConstraint = fullscreenView?.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView?.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leftConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
        self.view.layoutIfNeeded()
        fullscreenView?.layer.cornerRadius = 16
        
        //エンド地点
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.topConstraint?.constant = 0
            self.leftConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        })
    }
    
    var startingFrame: CGRect?
    
    func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.appFullscreenController?.tableView.contentOffset = .zero
            self.appFullscreenController?.tableView.scrollToRow(at: [0, 0], at: .top, animated: true)
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leftConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            self.view.layoutIfNeeded()
            self.tabBarController?.tabBar.transform = .identity
        }, completion: { _ in
            self.fullscreenView?.removeFromSuperview()
            self.appFullscreenController?.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
}
