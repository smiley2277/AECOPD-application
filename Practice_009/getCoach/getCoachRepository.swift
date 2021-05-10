//
//  getCoachRepository.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/29.
//

import Foundation
import UIKit
import RxSwift

class getCoachRepository {
    static let shared = getCoachRepository()
    func getCoach(userId: String, borg_uuid: String, timestamp: String) -> Single<PatientCoach> { 
        let api = APIManager.shared.getCoach(userId: userId, borg_uuid: borg_uuid, timestamp: timestamp)
        return LoginRepository.shared.localAuthorizationData
            .flatMap({_ in api})
            .map{ PatientCoach(JSON: $0)! } //model
    }
}
