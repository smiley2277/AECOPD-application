import UIKit

protocol LoginViewProtocol: BaseViewControllerProtocol {
    func onBindLoginResult(loginResult: LoginResult)
    func onBindLocalAuthoriztion(localAuthoirizationData: (userID: String?, roles: LoginResult.Data.AdminOrUser))
}

protocol LoginPresenterProtocol: NSObjectProtocol {
    func getLoginResult(email: String, password: String)
    func getLocalAuthorization()
}
