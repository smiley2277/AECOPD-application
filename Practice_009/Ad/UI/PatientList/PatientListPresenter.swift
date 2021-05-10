import UIKit
import RxSwift

class PatientListPresenter: NSObject, PatientListPresenterProtocol {
    weak var delegate: PatientListViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = PatientListRepository.shared
    
    required init(delegate: PatientListViewProtocol) {
        self.delegate = delegate
    }
    
    func getGroupAdmin() {
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.getGroupAdmin().subscribe(onSuccess:{ (model) in
            self.delegate?.onBindGroupAdmin(groupAdmin: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }
}
