//
//  signUpPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/22.
//

import Foundation
import UIKit
import RxSwift

class signUpToBackendPresenter: NSObject, signUpToBackendPresenterProtocol {
    weak var delegate: signUpToBackendViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = signUpToBackendRepository.shared
    
    required init(delegate: signUpToBackendViewProtocol) {
        self.delegate = delegate
    }
    
    func getSignUpResult(lastname: String, firstname: String, age: Int, email: String, birthday: String, gender: String, height: Int, weight: Int, phone: String, identity: String, password: String){
        repository.getSignUpResult(lastname: lastname, firstname: firstname, age: age, email: email, birthday: birthday, gender: gender, height: height, weight: height, phone: phone, identity: identity, password: password).subscribe(onSuccess:{ (model) in
            if (model.status == "Success") {
                print("SUCCESS", model)
                self.delegate?.onBindSignUpResult(SignUpResult: model)
            } else {
                self.delegate?.onBindSignUpErrorResult()
            }
        }, onError: {error in
//            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
}
