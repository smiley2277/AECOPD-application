//
//  getCoachProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/29.
//

import Foundation
import UIKit

protocol getCoachViewProtocol: BaseViewControllerProtocol {
    func onBindGetCoachResult(Result: LoginResult) //model
}

protocol getCoachPresenterProtocol: NSObjectProtocol {
    func getCoach(userId: String, borg_uuid: String, timestamp: String)
}

