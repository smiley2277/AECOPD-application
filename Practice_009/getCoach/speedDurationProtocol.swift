//
//  speedDurationProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/28.
//

import Foundation
import UIKit

protocol speedDurationViewProtocol: NSObjectProtocol {
    func onBindSettingErrorResult()
    func onBindSettingResult()
}

protocol speedDurationPresenterProtocol: NSObjectProtocol {
    func getCoach(userId: String, borg_uuid: String, timestamp: String)
}
