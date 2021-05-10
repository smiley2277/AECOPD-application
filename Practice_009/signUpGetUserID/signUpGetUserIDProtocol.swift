//
//  signUpGetUserIDProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//

import Foundation
import UIKit

protocol signUpGetUserIDViewProtocol: BaseViewControllerProtocol {
    func onBindGetUserIDResult(SignUpResult: LoginResult)
}

protocol signUpGetUserIDPresenterProtocol: NSObjectProtocol {
    func getUserID(email: String, password: String)
}

