import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var errorHint: UILabel!
    
    private var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        presenter = LoginPresenter(delegate: self)
        
        login.layer.cornerRadius = 4
        login.backgroundColor = UIColor.systemIndigo
        login.tintColor = UIColor.white

        userID.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        password.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        enableLoginButton(false)
        
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .hidden)
//
//        if UserDefaultUtil.shared.adminAuthorization != "" && UserDefaultUtil.shared.adminAuthorization != nil {
//            let storyboard = UIStoryboard(name: "PatientDetailTabList", bundle: Bundle.main)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PatientDetailTabListViewController") as! PatientDetailTabListViewController
//            //TODO
//            vc.setUserId(userId: "test_id3")
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func onTouchLogin(_ sender: Any) {
        if userID.text == "" || userID.text == nil { return }
        if password.text == "" || password.text == nil { return }
        presenter?.getLoginResult(email: userID.text!, password: password.text!)
        clearTextField()
    }
    
    private func enableLoginButton(_ isEnable: Bool) {
        login.alpha = isEnable ? 1 : 0.5
        login.isUserInteractionEnabled = isEnable
    }
    
    private func enableLoginErrorHint(_ isEnable: Bool) {
        errorHint.text = isEnable ? "請檢查帳號、密碼，然後再試一次" : ""
        //TODO r500
    }
    
    private func clearTextField() {
        userID.text = ""
        password.text = ""
    }
}

extension LoginViewController: LoginViewProtocol {
    func onBindLoginResult(loginResult: LoginResult) {
        let storyboard = UIStoryboard(name: "PatientList", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        //TODO 記在手機，持續登入
    }
    
    func onBindLoginErrorResult(){
        enableLoginErrorHint(true)
    }
}

extension LoginViewController {
    @objc func textDidChange() {
        enableLoginErrorHint(false)
        let isFilled = !(userID.text == "" || password.text == "")
        enableLoginButton(isFilled)
    }
}
