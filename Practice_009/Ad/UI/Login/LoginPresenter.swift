import UIKit
import RxSwift

class LoginPresenter: NSObject, LoginPresenterProtocol {
    weak var delegate: LoginViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = LoginRepository.shared
    
    required init(delegate: LoginViewProtocol) {
        self.delegate = delegate
    }
    
    func getLoginResult(email: String, password: String){
        repository.getLoginResult(email: email, password: password).subscribe(onSuccess:{ (model) in
            if (model.status == "Success") {
                self.delegate?.onBindLoginResult(loginResult: model)
            } else {
                self.delegate?.onApiError(error: APIError.init(type: .apiFailException, localDesc: "", alertMsg: ""))
            }
        }, onError: { error in
            self.repository.setLocalAdminLoginResult(nil)
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
    
    func getLocalAuthorization(){
        LoginRepository.shared.localAuthorizationData.subscribe(onSuccess:{  (model) in
            self.delegate?.onBindLocalAuthoriztion(localAuthoirizationData: model)
        }, onError: { error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
}
