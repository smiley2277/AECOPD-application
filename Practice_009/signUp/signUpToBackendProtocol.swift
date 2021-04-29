//
//  signUpToBackendProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/22.

//

import Foundation
import UIKit

protocol signUpToBackendViewProtocol: BaseViewControllerProtocol {
    func onBindSignUpResult(SignUpResult: LoginResult)
}

protocol signUpToBackendPresenterProtocol: NSObjectProtocol {
    func getSignUpResult(lastname: String, firstname: String, age: Int, email: String, birthday: String, gender: String, height: Int, weight: Int, phone: String, identity: String, password: String, user_id: String)
}
