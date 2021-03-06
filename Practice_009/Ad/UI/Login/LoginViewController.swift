import UIKit
import RxSwift

protocol LoginViewControllerProtocol: NSObjectProtocol {
    func onSignUpSuccess(loginResult: LoginResult)
}

extension LoginViewController {
    func setIsNeedToRedirect(_ isNeedToRedirect: Bool, isFirstLaunchApp: Bool) {
        self.isNeedToRedirect = isNeedToRedirect
        self.isFirstLaunchApp = isFirstLaunchApp
    }
}

class LoginViewController: BaseViewController {
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var errorHint: UILabel!
    
    private var presenter: LoginPresenterProtocol?
    private var isNeedToRedirect = true
    private var isFirstLaunchApp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(delegate: self)
        
        login.layer.cornerRadius = 4
        login.backgroundColor = UIColor.systemIndigo
        login.tintColor = UIColor.white

        userID.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        password.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        enableLoginButton(false)
        
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .hidden)

        if isNeedToRedirect {
            presenter?.getLocalAuthorization()
        }
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
    }
    
    private func clearTextField() {
        userID.text = ""
        password.text = ""
    }
}

extension LoginViewController: LoginViewProtocol {
    func onBindLoginResult(loginResult: LoginResult) {
        let userID = loginResult.data!.userId
        let roles = loginResult.data!.roles!
        onBindLocalAuthoriztion(localAuthoirizationData: (userID: userID, roles: roles))
    }
    
    func onBindLocalAuthoriztion(localAuthoirizationData data: (userID: String?, roles: LoginResult.Data.AdminOrUser)) {
        if data.roles == .admin {
            //MARK: 導頁到管理者頁面
            let storyboard = UIStoryboard(name: "PatientList", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "PatientListViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if data.userID == "" || data.userID == nil {
                //TODO 導頁Auth
            } else {
                //TODO 導頁User
            }
        }
    }
    
    override func onApiError(error: APIError) {
        if error.type == .apiUnauthorizedException {
            LoginRepository.shared.setLocalAdminLoginResult(nil)
            enableLoginErrorHint(!isFirstLaunchApp)
        } else {
            let controller = UIAlertController(title: "", message: error.alertMsg , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
}

extension LoginViewController {
    @objc func textDidChange() {
        enableLoginErrorHint(false)
        let isFilled = !(userID.text == "" || password.text == "")
        enableLoginButton(isFilled)
    }
}
