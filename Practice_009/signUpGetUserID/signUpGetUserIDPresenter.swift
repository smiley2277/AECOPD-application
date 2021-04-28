//
//  signUpGetUserIDPresenter.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//

import UIKit
import RxSwift

class signUpGetUserIDPresenter: NSObject, signUpGetUserIDPresenterProtocol{
    weak var delegate: signUpGetUserIDViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = signUpGetUserIDRepository.shared
    
    required init(delegate: signUpGetUserIDViewProtocol) {
        self.delegate = delegate
    }
}
