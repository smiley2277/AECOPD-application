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
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.getLoginResult(email: email, password: password).subscribe(onSuccess:{ (model) in
            if (model.status == "Success") {
                self.delegate?.onBindLoginResult(loginResult: model)
            } else {
                self.delegate?.onApiError(error: APIError.init(type: .apiFailException, localDesc: "", alertMsg: ""))
            }
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { error in
            self.repository.setLocalAdminLoginResult(nil)
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }
    
    func getLocalAuthorization(){
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        LoginRepository.shared.localAuthorizationData.subscribe(onSuccess:{  (model) in
            self.delegate?.onBindLocalAuthoriztion(localAuthoirizationData: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }
}
