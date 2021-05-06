//
//  getCoachPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/29.
//

import Foundation
import UIKit
import RxSwift

class getCoachPresenter: NSObject, getCoachPresenterProtocol {
    func getCoach(userId: String, borg_uuid: String, timestamp: String) {
        repository.getCoach(userId: userId, borg_uuid: borg_uuid, timestamp: timestamp).subscribe(onSuccess:{ (model) in
                self.delegate?.onBindGetCoachResult(Result: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
    weak var delegate: getCoachViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = getCoachRepository.shared
    
    required init(delegate: getCoachViewProtocol) {
        self.delegate = delegate
    }
    
}
