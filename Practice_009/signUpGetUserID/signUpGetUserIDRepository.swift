//
//  signUpGetUserIDRepository.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//
import UIKit
import RxSwift

class signUpGetUserIDRepository {
    static let shared = signUpGetUserIDRepository()
//    func getLoginResult(email: String, password: String) -> Single<LoginResult> {
//        let api = APIManager.shared.getLoginResult(email: email, password: password)
//        return api
//            .map{ LoginResult(JSON: $0)! }
//            .flatMap{ response -> Single<LoginResult> in
//                return self.procressToken(loginResult: response)
//            }
//    }
}
