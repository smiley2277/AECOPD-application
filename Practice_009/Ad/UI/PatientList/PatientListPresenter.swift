import UIKit
import RxSwift

class PatientListPresenter: NSObject, PatientListPresenterProtocol {
    weak var delegate: PatientListViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = PatientListRepository.shared
    
    required init(delegate: PatientListViewProtocol) {
        self.delegate = delegate
    }
    
    func getPatientList() {
        repository.getPatientList().subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientList()
        }, onError: {error in
            //TODO 異常處理
            print(error)
        }).disposed(by: disposeBag)
    }
}
