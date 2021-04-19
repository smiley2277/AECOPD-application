import UIKit
import UserNotifications

extension BaseViewController {
    //非立即轉變
    func setTabBarType(tabBarType: TabBarType) {
        self.tabBarType = tabBarType
    }

    //非立即轉變
    func setNavType(navBarType: NavBarType) {
        self.navBarType = navBarType
    }

    //非立即轉變
    func setNavBarItem(left: NavLeftType, mid: NavMidType, right: NavRightType) {
        self.navLeftType = left
        self.navMidType = mid
        self.navRightType = right
    }

    func setBarAlpha(animate: Bool) {
        switch animate {
        case true:
            UIView.animate(withDuration: 0.2) {
                self.adjustNavTitle()
                self.adjustBarAlpha()
                self.adjustNavShadow()
            }
        case false:
            adjustNavTitle()
            adjustBarAlpha()
            adjustNavShadow()
        }
    }

    func setBarAlpha(alpha: CGFloat, animate: Bool) {
        self.navAlpha = alpha
        setBarAlpha(animate: animate)
    }

    func setNavTitle(title: String) {
        self.navTitle = title
        self.adjustNavTitle()
    }
    
    func setNavTitleColor(_ color: UIColor) {
        self.navTitleColor = color
    }

    //非立即轉變
    func setIsNavHideWhenSwipe(_ enable: Bool) {
        self.isNavHidesBarsOnSwipe = enable
    }

    //非立即轉變
    func setIsNavShadowEnable(_ enable: Bool) {
        self.isNavShadowEnable = enable
    }

    //非立即轉變、使用前要setNavType .custom
    func setCustomLeftBarButtonItem(barButtonItem : UIBarButtonItem?) {
        self.customLeftBarButtonItem = barButtonItem
    }

    //非立即轉變、使用前要setNavType .custom
    func setCustomMidBarButtonItem(view : UIView?) {
        self.customMidBarButtonItem = view
    }
    
    //非立即轉變、使用前要setNavType .custom
    func setCustomRightBarButtonItems(barButtonItems : [UIBarButtonItem]?) {
        self.customRightBarButtomItems = barButtonItems
    }
    
    func setBarTypeLayoutImmediately() {
        adjustViewAppearance()

        adjustBarIsHiddenOrNot()
        adjustNavBarItem()

        adjustNavTitle()
        adjustNavTitleColor()
        adjustBarAlpha()
        adjustNavShadow()
        adjustTabBarHeight()
        adjustNavHideWhenSwipe()
    }
}

//MARK: Other
extension BaseViewController {
    func getVC(st: String, vc: String) -> UIViewController {
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)

        return viewController
    }

    func safeReload(tableView: UITableView, section: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }

        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
        tableView.endUpdates()
    }

    func safeReload(tableView: UITableView, section: Int, row: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }

        if (tableView.numberOfRows(inSection: section) < row + 1) {
            //如果Section中row數量不到row，不reload
            return
        }

        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath.init(row: row, section: section)], with: .fade)
        tableView.endUpdates()
    }

    func safeReload(tableView: UITableView, numberOfSection: Int) {
        if (tableView.numberOfRows(inSection: numberOfSection) == 0) {
            //如果Section中row數量為零，不reload
            return
        }
        let range = NSMakeRange(0, numberOfSection)
        let sections = NSIndexSet(indexesIn: range)

        tableView.beginUpdates()
        tableView.reloadSections(sections as IndexSet, with: .fade)
        tableView.endUpdates()
    }

}

class BaseViewController: UIViewController {
    private var loadingAPICount = 0
    private var tabBarType: TabBarType = .notHidden
    private var navBarType: NavBarType = .notHidden
    private var navLeftType: NavLeftType = .defaultType
    private var navMidType: NavMidType = .textTitle
    private var navRightType: NavRightType = .nothing

    private var isNavHideWhenSwipe = false
    private var isNavShadowEnable = true
    private var isNavHidesBarsOnSwipe = false
    private var isPageSheetPresenting = false
    private var statusBar : UIView? {
        if #available(iOS 13.0, *) {
            if let existStatusBar = UIApplication.shared.keyWindow?.subviews.filter({$0.restorationIdentifier == "statusBar"}).first {
                existStatusBar.layer.zPosition = 1
                return existStatusBar
            }else{
                let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBar.restorationIdentifier = "statusBar"
                UIApplication.shared.keyWindow?.addSubview(statusBar)
                return statusBar
            }
        } else {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }

    private var navAlpha: CGFloat = 1.0

    private var navTitle: String = ""
    private var navTitleColor: UIColor = ColorHexUtil.hexColor(hex: "#333333")

    private var nilButton: UIBarButtonItem?
    
    private var customLeftBarButtonItem : UIBarButtonItem?
    private var customMidBarButtonItem : UIView?
    private var customRightBarButtomItems : [UIBarButtonItem]?

    
    var topAnchor: NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return view.topAnchor
        }
    }
    
    var leadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.leadingAnchor
        } else {
            return view.leadingAnchor
        }
    }
    
    var trailingAnchor: NSLayoutXAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return view.trailingAnchor
        }
    }
    
    var bottomAnchor: NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return view.bottomAnchor
        }
    }

    enum TabBarType {
        case notHidden
        case hidden
    }

    enum NavBarType {
        case notHidden
        case hidden
    }

    enum NavLeftType {
        case defaultType
        case close
        case custom
    }

    enum NavMidType {
        case textTitle
        case custom
    }

    enum NavRightType {
        case nothing
        case custom
        case nothingWithEmptySpace
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNilButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBarTypeLayoutImmediately()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func adjustViewAppearance() {
        self.navigationController?.navigationBar.accessibilityIdentifier = "navigationBar"
    }

}

//MARK: Nav Appearance
extension BaseViewController {
    private func adjustBarIsHiddenOrNot() {
        switch tabBarType {
        case .notHidden:
            self.tabBarController?.tabBar.isHidden = false
        case .hidden:
            self.tabBarController?.tabBar.isHidden = true
        }

        switch navBarType {
        case .notHidden:
            self.navigationController?.navigationBar.isHidden = false
        case .hidden:
            self.navigationController?.navigationBar.isHidden = true
        }
    }

    private func adjustNavBarItem() {
        if (navBarType == .hidden) {
            return
        }
        switch navLeftType {
        case .defaultType:
            self.navigationItem.leftBarButtonItem = nil

            //MARK: 因為storyBoard Nav右邊的back要給一個空白
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem?.title = " "
            self.navigationController?.navigationBar.backItem?.title = " "
            self.navigationController?.navigationBar.topItem?.title = " "
        case .close:
            let closeImage = UIImage.init(systemName: "xmark")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: closeImage, style: .plain, target: self, action: #selector(onTouchNavClose))

        case .custom:
            self.navigationItem.leftBarButtonItem = customLeftBarButtonItem
        }

        switch navMidType {
        case .textTitle:
            self.navigationItem.titleView = nil
            self.adjustNavTitle()

        case .custom:
            self.navigationItem.titleView = customMidBarButtonItem
        }

        switch navRightType {
        case .nothing:
            self.navigationItem.rightBarButtonItem = nilButton
            
        case .nothingWithEmptySpace:
            self.navigationItem.rightBarButtonItem = nil
            
        case .custom:
            self.navigationItem.rightBarButtonItems = customRightBarButtomItems
        }

    }
    
    func setIsPageSheetPresenting(isPresentVC:Bool) {
        isPageSheetPresenting = isPresentVC
    }
    
    private func adjustBarAlpha() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(navAlpha)
        if isPageSheetPresenting == true && self.modalPresentationStyle == .pageSheet {
            self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
            statusBar?.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            return
        }
        switch navAlpha {
        case 1.0:
            self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
            statusBar?.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default

        case 0.0:
            self.navigationController?.navigationBar.tintColor = UIColor.white
            statusBar?.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black

        default: ()
        }
    }

    private func adjustNavShadow() {
        if (self.isNavShadowEnable == false) {
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 0), opacity: 0.0, shadowRadius: 0)
            return
        }
        switch navAlpha {
        case 1.0:
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 2)
        case 0.0:
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 0), opacity: 0.0, shadowRadius: 0)
        default: ()
        }
    }

    private func adjustNavTitle() {
        switch navAlpha {
        case 1.0:
            self.navigationItem.title = navTitle
        case 0.0:
            self.navigationItem.title = ""
        default: ()
        }
    }
    
    private func adjustNavTitleColor() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: navTitleColor]
    }

    private func adjustNavHideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = isNavHideWhenSwipe
    }

    private func setUpNilButton() {
        let barButton = UIBarButtonItem(customView: UIView())
        barButton.customView?.frame = CGRect(x: 0, y: 0, width: 40, height: 56)
        self.nilButton = barButton
    }

    private func adjustTabBarHeight() {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                let screenWidth = UIScreen.main.bounds.width
                self.tabBarController?.tabBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.view.safeAreaInsets.bottom, width: screenWidth, height: self.view.safeAreaInsets.bottom)
            }
        }
    }

    //Note: 通常不會需要override，只有在TouchClose需要特別事件的時候
    //Note: EX: B彈出C，點C的close，需要連同Ｂ一起close
    @objc func onTouchNavClose() {
        //Note: 需要時可覆寫
        self.dismiss(animated: true, completion: nil)
    }
}

class CustomSearchBar: UISearchBar {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UILayoutFittingExpandedSize.width, height: 56.0)
    }
}

