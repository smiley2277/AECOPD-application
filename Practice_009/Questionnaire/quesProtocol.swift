//
//  quesProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/27.
//

import Foundation
import UIKit

protocol quesViewProtocol: NSObjectProtocol {
    func onBindQuesResult(SignUpResult: LoginResult)
    func onBindQuesErrorResult()
}

protocol quesPresenterProtocol: NSObjectProtocol {
    func postQues(userId: String, cat1: Int, cat2: Int, cat3: Int, cat4: Int, cat5: Int, cat6: Int, cat7: Int, cat8: Int, catsum: Int, eq1: Int, eq2: Int, eq3: Int, eq4: Int, eq5: Int, mmrc: Int, timestamp: String)
}

