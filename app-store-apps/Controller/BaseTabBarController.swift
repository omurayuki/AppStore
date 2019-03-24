import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createNavController(vc: AppsSearchController(), title: "Search", imageName: #imageLiteral(resourceName: "search")),
            createNavController(vc: UIViewController(), title: "Today", imageName: #imageLiteral(resourceName: "today_icon")),
            createNavController(vc: UIViewController(), title: "Apps", imageName: #imageLiteral(resourceName: "apps")),
        ]
    }
    
    fileprivate func createNavController(vc: UIViewController, title: String, imageName: UIImage) -> UIViewController {
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        vc.navigationItem.title = title
        vc.view.backgroundColor = .white
        vc.tabBarItem.title = title
        vc.tabBarItem.image = imageName
        return navVC
    }
}
