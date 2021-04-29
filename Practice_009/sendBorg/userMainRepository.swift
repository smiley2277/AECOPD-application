//
//  userMainRepository.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/24.
//

import Foundation
import UIKit
import RxSwift

class userMainRepository {
    static let shared = userMainRepository()
    func postBorg(userId:String, postbeat: Int, postborg: Int, prebeat: Int, preborg: Int, step: Int, timestamp: String) -> Single<PostBorg> {
        let api = APIManager.shared.postBorg(userId:userId, postbeat: postbeat,postborg: postborg, prebeat: prebeat, preborg: preborg, step: step, timestamp: timestamp)
        return LoginRepository.shared.localAuthorizationData
            .flatMap({_ in api})
            .map{ PostBorg(JSON: $0)! }
    }
}
