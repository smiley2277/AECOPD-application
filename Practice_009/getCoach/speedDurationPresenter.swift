//
//  speedDurationPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/28.
//

import Foundation

import UIKit
import RxSwift

class speedDurationPresenter: NSObject, speedDurationPresenterProtocol {
    weak var delegate: speedDurationViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = speedDurationRepository.shared
    
    required init(delegate: speedDurationViewProtocol) {
        self.delegate = delegate
    }
    
    func getCoach(userId: String, borg_uuid: String, timestamp: String){
        repository.getCoach(userId: userId, borg_uuid: borg_uuid, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            if (model.status == "Success") {
                print("SUCCESS", model)
                self.delegate?.onBindSettingResult()
            } else {
                self.delegate?.onBindSettingErrorResult()
            }
        }, onError: {error in
//            self.repository.setLocalAdminLoginResult(nil)
            self.delegate?.onBindSettingErrorResult()
        }).disposed(by: disposeBag)
    }
}
