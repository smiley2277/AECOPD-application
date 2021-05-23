//
//  signUpGetUserIDPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//

import UIKit
import RxSwift

class signUpGetUserIDPresenter: NSObject, signUpGetUserIDPresenterProtocol{
    weak var delegate: signUpGetUserIDViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = signUpGetUserIDRepository.shared
    
    required init(delegate: signUpGetUserIDViewProtocol) {
        self.delegate = delegate
    }
    func getUserID(email: String, password: String){
        repository.getUserID(email: email, password: password).subscribe(onSuccess:{ (model) in
                self.delegate?.onBindGetUserIDResult(SignUpResult: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
    func putUserID(user_id: String){
        repository.putUserID(user_id: user_id).subscribe(onSuccess:{ (model) in
                self.delegate?.onBindPutUserIDResult(statusResult: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
}
