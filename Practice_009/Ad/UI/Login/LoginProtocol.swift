import UIKit

protocol LoginViewProtocol: NSObjectProtocol {
    func onBindLoginResult(loginResult: LoginResult)
    func onBindLoginErrorResult()
}

protocol LoginPresenterProtocol: NSObjectProtocol {
    func getLoginResult(email: String, password: String)
}
