//
//  signUpToBackendRepository.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/22.
//

import Foundation
import UIKit
import RxSwift

class signUpToBackendRepository {
    static let shared = signUpToBackendRepository()
    func getSignUpResult(lastname: String, firstname: String, age: Int, email: String, birthday: String, gender: String, height: Int, weight: Int, phone: String, identity: String, password: String) -> Single<LoginResult> {
        
        let api = APIManager.shared.getSignUpResult(lastname: lastname, firstname: firstname, age: age, email: email, birthday: birthday, gender: gender, height: height, weight: height, phone: phone, identity: identity, password: password)
        return api
            .map{ LoginResult(JSON: $0)! }
//            .flatMap{ response -> Single<LoginResult> in
//                return self.procressToken(loginResult: response)
//            }
    }
}
