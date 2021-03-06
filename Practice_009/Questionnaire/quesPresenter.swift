//
//  quesPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/27.
//

import Foundation
import UIKit
import RxSwift

class quesPresenter: NSObject, quesPresenterProtocol {
    func postQues(userId: String, cat1: Int, cat2: Int, cat3: Int, cat4: Int, cat5: Int, cat6: Int, cat7: Int, cat8: Int, catsum: Int, eq1: Int, eq2: Int, eq3: Int, eq4: Int, eq5: Int, mmrc: Int, timestamp: String) {
        repository.postQues(userId: userId, cat1: cat1, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5, cat6: cat6, cat7: cat7, cat8: cat8, catsum: catsum, eq1: eq1, eq2: eq2, eq3: eq3, eq4: eq4, eq5: eq5, mmrc: mmrc, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            if (model.status == "Success") {
                print("SUCCESS", model)
                self.delegate?.onBindQuesResult(SignUpResult: model)
            } else {
                self.delegate?.onBindQuesErrorResult()
            }
        }, onError: {error in
            self.delegate?.onBindQuesErrorResult()
        }).disposed(by: disposeBag)
    }
    
    weak var delegate: quesViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = quesRepository.shared
    
    required init(delegate: quesViewProtocol) {
        self.delegate = delegate
    }
    
}

