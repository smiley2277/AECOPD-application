//
//  userMainPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/24.
//

import Foundation
import UIKit
import RxSwift

class userMainPresenter: NSObject, userMainPresenterProtocol{
    func postBorg(userId: String, postbeat: Int, postborg: Int, prebeat: Int, preborg: Int, step: Int, timestamp: String) {
        repository.postBorg(userId: userId, postbeat: postbeat,postborg: postborg, prebeat: prebeat, preborg: preborg, step: step, timestamp: timestamp).subscribe(onSuccess:{ (model) in
                        self.delegate?.onBindMainResult(mainResult: model)
                }, onError: {error in
                    self.delegate?.onApiError(error: error as! APIError)
                }).disposed(by: disposeBag)
        
    }
    weak var delegate: userMainViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = userMainRepository.shared
    
    required init(delegate: userMainViewProtocol) {
        self.delegate = delegate
    }
}
