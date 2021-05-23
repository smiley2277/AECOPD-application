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
    func getUserID(email: String, password: String) -> Single<LoginResult> {
        let api = APIManager.shared.getUserID(email: email, password: password)
        return api
            .map{ LoginResult(JSON: $0)! }
    }
    func putUserID(user_id: String) -> Single<PostQues> {
        let api = APIManager.shared.putUserID(user_id: user_id)
        return api
            .map{ PostQues(JSON: $0)! }
    }
}
