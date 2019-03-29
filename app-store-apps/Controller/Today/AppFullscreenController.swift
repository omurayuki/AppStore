import UIKit

class AppFullscreenController: UITableViewController {
    
    var dismissHandler: (() -> Void)?
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = todayItem?.backgroundColor
        tableView.contentInset = .init(top: 0, left: 0, bottom: UIApplication.shared.statusBarFrame.height, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.closeBtn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            return headerCell
        }
        let cell = AppFullscreenDescriptionCell()
        cell.backgroundColor = todayItem?.backgroundColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc
    func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}
