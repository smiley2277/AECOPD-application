//
//  speedDurationRepository.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/28.
//

import Foundation
import UIKit
import RxSwift

class speedDurationRepository {
    static let shared = speedDurationRepository()
    
    func getCoach(userId: String, borg_uuid: String, timestamp: String) -> Single<LoginResult> {
        
        let api = APIManager.shared.getCoach(userId: userId, borg_uuid: borg_uuid, timestamp: timestamp)
        return api
            .map{ LoginResult(JSON: $0)! }
//            .flatMap{ response -> Single<LoginResult> in
//                return self.procressToken(loginResult: response)
//            }
    }
}

