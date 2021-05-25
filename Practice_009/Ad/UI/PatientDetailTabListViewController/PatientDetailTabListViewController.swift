import UIKit

extension PatientDetailTabListViewController {
    func setDefaultPage(_ leftOrRight: LeftOrRight){
        self.defaultPage = leftOrRight
    }
    
    func setUserId(userId: String, patientName: String, identity: String) {
        self.userId = userId
        self.patientName = patientName
        self.identity = identity
    }
}

class PatientDetailTabListViewController: BaseViewController {
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageLeftButton: UIButton!
    @IBOutlet weak var topPageRightButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBorderView: UIView!
    @IBOutlet weak var backgroundGrayView: UIView!
    @IBOutlet weak var addCoachContainerView: UIView!
    
    @IBOutlet weak var showAddCoachStackViewButton: UIButton!
    @IBOutlet weak var showAddCoachStackViewBorderView: UIView!
   
    @IBOutlet weak var addCoachContainerViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var addCoachContainerViewHeight: NSLayoutConstraint!
    private var isDatePickerViewShowing = false
    private var isAddSuggestStackViewShowing = false
    
    private var defaultPage: LeftOrRight = .left
    private var isNeedShowDefaultPage = true
    
    private var patientDetailLeftViewController: PatientDetailViewController?
    private var patientDetailRightViewController: PatientDetailViewController?
    private var patientDetailAddCoachViewController: PatientDetailTabListAddCoachViewController?
    
    private var userId: String?
    private var patientName: String?
    private var identity: String?
    private var presenter: PatientDetailTabListPresenterProtocol?

    private var patientSurvey: PatientSurvey?
    private var patientCoach: PatientCoach?
    private var patientBorg: PatientBorg?
    
    private var patientBorgAndCoachList : [PatientBorgAndCoach] = []
    
    private var keyboardHeight: CGFloat = 301
    
    enum LeftOrRight {
        case left
        case right
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .custom)
        self.setIsNavShadowEnable(false)

        self.setNavTitle(title: "\(patientName ?? "") \(identity!)")
        self.setTabBarType(tabBarType: .hidden)

        let calendarButton = UIButton.init(type: .system)
        calendarButton.setImage(UIImage.init(systemName: "calendar") , for: .normal)
        calendarButton.setTitle("", for: .normal)
        calendarButton.addTarget(self, action: #selector(onTouchCalendarButton), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: calendarButton)
  
        self.setCustomRightBarButtonItems(barButtonItems: [barButtonItem])
        

        datePickerBorderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)
        datePicker.addTarget(self, action: #selector(onChangeDate(_:)), for: .valueChanged)

        addCoachContainerView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)

        showAddCoachStackViewBorderView.setBorder(width: 0, radius: 25, color: UIColor.lightGray)
        showAddCoachStackViewBorderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.4, shadowRadius: 4)
        showAddCoachStackViewButton.addTarget(self, action: #selector(onTouchPencilButton), for: .touchUpInside)
        
      
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchBackgroundGrayView))
        backgroundGrayView.addGestureRecognizer(ges)
        
        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(toPage: 0)
        
        datePicker.date = Date()
        
        presenter = PatientDetailTabListPresenter(delegate: self)
        loadData()

        self.addCoachContainerViewBottom.constant = 301
        self.viewReload()
    }
    
    @objc func keyboardWillShow(_ notification:Notification)
    {
        if patientDetailAddCoachViewController?.isAddingCoachCount ?? true { return }
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.2, animations: {
            self.addCoachContainerViewBottom.constant = keyboardRectangle.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        if patientDetailAddCoachViewController?.isAddingCoachCount ?? true { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.addCoachContainerViewBottom.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNeedShowDefaultPage == false { return }
        isNeedShowDefaultPage = false
        switch defaultPage {
        case .left:
            self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
        case .right:
            self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func adjustViewAppearance() {
        super.adjustViewAppearance()
        
        topPageButtonView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4, color: UIColor.black.withAlphaComponent(0.8))
    }
    
    private func loadData() {
        patientBorgAndCoachList = []
        presenter?.getPatientSurvey(userId: userId!, timestamp: DateFormat.shared.dateFormat(date: datePicker.date))
        presenter?.getPatientBorg(userId: userId!, timestamp: DateFormat.shared.dateFormat(date: datePicker.date))
    }
    
    private func getPatientCoach(borgUUID: String) {
        presenter?.getPatientCoach(userId: userId!, timestamp: DateFormat.shared.dateFormat(date: datePicker.date), borgUUID: borgUUID)
    }
    
    private func postPatientCoach(addCoachList: [(speed: Double?, time: Double?)]) {
        let now = Date()
        let timeStamp = DateFormat.shared.dateFormatLong(date: now)
        //MARK: 目前都回覆最後一個borgUUID (有bug 因為當天最後一個不一定是資料庫裡面最後一個)
        let borgUUID = patientBorgAndCoachList.first(where: {$0.isBorg})?.borgUUID
        //TODO remove空的
        let patientCoachList = addCoachList.filter({ $0.speed != nil || $0.time != nil })
        if patientCoachList.isEmpty { return }
        if borgUUID == nil {
            showThatDateNoBorgHint()
            return
        }
        presenter?.postPatientCoach(userId: userId!, timeStamp: timeStamp, borgUUID: borgUUID!, patientCoachList: patientCoachList)
    }
    
    private func viewReload(){
        self.view.isUserInteractionEnabled = false

        topPageButtonReload()
        patientDetailLeftViewController?.setPatientBorgAndCoachList(patientBorgAndCoachList)
        
        patientDetailRightViewController?.setPatientSurvey(patientSurvey)

        self.view.isUserInteractionEnabled = true
    }
    
    private func topPageButtonReload(){
        self.topPageLeftButton.setTitle(" 建議 ", for: .normal)
        self.topPageRightButton.setTitle(" 問卷 ", for: .normal)
    }
    
    @objc private func onTouchCalendarButton() {
        isDatePickerViewShowing = !isDatePickerViewShowing
        isAddSuggestStackViewShowing = false
        enableDatePickerView(isDatePickerViewShowing)
        enableAddSuggestStackView(isAddSuggestStackViewShowing)
        enableBackgroundGrayView(isDatePickerViewShowing)
    }
    
    @objc private func onChangeDate(_ sender: UIDatePicker) {
        loadData()
        isDatePickerViewShowing = false
        enableDatePickerView(isDatePickerViewShowing)
        enableBackgroundGrayView(isDatePickerViewShowing)
        patientDetailAddCoachViewController!.setDate(date: datePicker.date)
    }
    
    private func enableDatePickerView(_ isEnable: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
                        self.datePicker.alpha = isEnable ? 1 : 0
                        self.datePickerBorderView.alpha = isEnable ? 1 : 0
                        self.backgroundGrayView.alpha = isEnable ? 1 : 0 })
    }
    
    @objc private func onTouchPencilButton() {
        let borgUUID = patientBorgAndCoachList.first(where: {$0.isBorg})?.borgUUID
        if borgUUID == nil {
            showThatDateNoBorgHint()
            return
        }
        isAddSuggestStackViewShowing = !isAddSuggestStackViewShowing
        isDatePickerViewShowing = false
        enableDatePickerView(isDatePickerViewShowing)
        enableAddSuggestStackView(isAddSuggestStackViewShowing)
        enableBackgroundGrayView(isAddSuggestStackViewShowing)
        if isAddSuggestStackViewShowing {
            patientDetailAddCoachViewController?.tableView.isScrollEnabled = false
            patientDetailAddCoachViewController!.focusOnPreviousEditingTextfield()
            patientDetailAddCoachViewController?.tableView.isScrollEnabled = true
        }
    }
    
    private func enableAddSuggestStackView(_ isEnable: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
                        self.addCoachContainerView.alpha = isEnable ? 1 : 0
        })
        
        if !isEnable {
            patientDetailLeftViewController?.view.endEditing(true)
            patientDetailRightViewController?.view.endEditing(true)
            self.view.endEditing(true)
        } else {
            //TODO
            //addCoachSpeedTextField.becomeFirstResponder()
        }
    }
    
    @objc private func onTouchBackgroundGrayView() {
        isAddSuggestStackViewShowing = false
        isDatePickerViewShowing = false
        enableDatePickerView(false)
        enableAddSuggestStackView(false)
        enableBackgroundGrayView(false)
    }
    
    private func enableBackgroundGrayView(_ isEnable: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
                        self.backgroundGrayView.alpha = isEnable ? 1 : 0 })
    }
    
    private func showThatDateNoBorgHint(){
        let alertController = UIAlertController(title: nil, message: "這天沒有填寫的問券哦!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "好", style: .default)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}

extension PatientDetailTabListViewController: PatientDetailTabListViewProtocol {

    func onBindPatientSurvey(patientSurvey: PatientSurvey) {
        self.patientSurvey = patientSurvey
        viewReload()
    }
    
    func onBindPatientBorg(patientBorg: PatientBorg) {
        self.patientBorg = patientBorg
        let dataList = patientBorg.data?.data.map({PatientBorgAndCoach(patientBorgData:  $0)}) ?? []
    
        self.patientBorgAndCoachList.append(contentsOf: dataList)
        self.patientBorgAndCoachList = self.patientBorgAndCoachList.sorted(by: {return $0.date! > $1.date!})
        
        let borgUUIDs = patientBorgAndCoachList.filter({ $0.isBorg }).map({ $0.borgUUID! })
        borgUUIDs.forEach({ getPatientCoach(borgUUID: $0) })
        viewReload()
    }
    
    func onBindPatientCoach(patientCoach: PatientCoach) {
        self.patientCoach = patientCoach
        var dataList = patientCoach.data?.data.map({PatientBorgAndCoach(patientCoachData:  $0)}) ?? []
        //MARK: 每個borgID底下coach的排序方式
        dataList.sort(by: {return $0.date! > $1.date!} )
        dataList.forEach({ data in
            //MARK: 找到特定的borg，再放到該筆後面
            let properIndex = patientBorgAndCoachList.lastIndex(where: { data.borgUUID! == $0.borgUUID! })
            if let index = properIndex {
                self.patientBorgAndCoachList.insert(data, at: index)
            }
        })
        viewReload()
    }

    func onBindPostPatientCoachResponse(postPatientCoachResponse: PostPatientCoachResponse) {

        if postPatientCoachResponse.status == "Success" {
            //tODO
            //addCoachSpeedTextField.text = ""
            //addCoachTimeTextField.text = ""
            loadData()
            //TODO: Refactor
            isAddSuggestStackViewShowing = false
            isDatePickerViewShowing = false
            enableDatePickerView(false)
            enableAddSuggestStackView(false)
            enableBackgroundGrayView(false)

        } else {
            //TODO: 異常處理
        }
    }
    
    func onErrorPostPatientCoachResponse() {
        //TODO: 異常處理
        //addCoachSpeedTextField.text = ""
       // addCoachTimeTextField.text = ""
    }
    
}

//MARK: scroll top page 左滑到右，右滑到左
extension PatientDetailTabListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != topPageScrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        //MARK: 使用者滑動時，滑超過一半就應該算下一頁，所以是4.0，不是2.0
        let nowPage = (nowOffsetX < wholeWidth / 4.0) ? 0 : 1
        let percent = nowOffsetX / (wholeWidth / 2.0)
        scrollTopPageButtonBottomLine(percent: percent)
        switchPageButton(toPage: nowPage)
    }
}

extension PatientDetailTabListViewController {
    @IBAction func onTouchLeftButton(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
    }
    
    @IBAction func onTouchRightButton(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
    }
    
    private func scrollToPage(scrollView: UIScrollView, page: Int, animated: Bool) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 2.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
    }
    
    private func switchPageButton(toPage: Int){
        switch toPage {
        case 0:
            enableButton(topPageLeftButton)
            disableButton(topPageRightButton)
        case 1:
            enableButton(topPageRightButton)
            disableButton(topPageLeftButton)
        default:
            ()
        }
    }
    
    private func enableButton(_ button: UIButton){
        button.tintColor = UIColor.systemIndigo
        button.setTitleColor(UIColor.systemIndigo, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Semibold", size: 16.0)
    }
    
    private func disableButton(_ button: UIButton){
        button.tintColor = UIColor.lightGray
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Regular", size: 16.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Left" {
            let viewController = segue.destination  as? PatientDetailViewController
            patientDetailLeftViewController = viewController
            viewController!.setIsShowSurvey(false)
            viewController!.setIsShowCoach(true)
            viewController!.setIsShowBorg(true)
        } else if segue.identifier == "Right" {
            let viewController = segue.destination  as? PatientDetailViewController
            patientDetailRightViewController = viewController
            viewController!.setIsShowSurvey(true)
            viewController!.setIsShowCoach(false)
            viewController!.setIsShowBorg(false)
        } else {
            let viewController = segue.destination as? PatientDetailTabListAddCoachViewController
            patientDetailAddCoachViewController = viewController
            patientDetailAddCoachViewController?.setDate(date: datePicker.date)
            viewController!.delegate = self
        }
    }
}

extension PatientDetailTabListViewController: PatientDetailTabListAddCoachViewControllerProtocol {
    func onChangedHeight(newHeight: CGFloat) {
        let spaceForTopSpace: CGFloat = 35
        let maxHeight = UIScreen.main.bounds.height - keyboardHeight - spaceForTopSpace
        UIView.animate(withDuration: 0.2, animations: {
            self.addCoachContainerViewHeight.constant = (newHeight + 20 > maxHeight) ? maxHeight : newHeight + 20
            self.patientDetailAddCoachViewController?.scrollToBottom()
            self.view.layoutIfNeeded()
      })
    }
    
    func onTouchSendButton(addCoachList: [(speed: Double?, time: Double?)]) {
        postPatientCoach(addCoachList: addCoachList)
    }
}
