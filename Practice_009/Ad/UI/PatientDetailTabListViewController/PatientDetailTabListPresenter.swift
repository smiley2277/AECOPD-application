import RxSwift

class PatientDetailTabListPresenter: NSObject, PatientDetailTabListPresenterProtocol {
    weak var delegate: PatientDetailTabListViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = PatientDetailTabListRepository.shared
    
    required init(delegate: PatientDetailTabListViewProtocol) {
        self.delegate = delegate
    }

    func postPatientCoach(userId: String, timeStamp: String, borgUUID: String, patientCoachList: [(speed: Double?, time: Double?)]){
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.postPatientCoach(userId: userId, timestamp: timeStamp, borgUUID: borgUUID, patientCoachList: patientCoachList).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPostPatientCoachResponse(postPatientCoachResponse: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }
    
    func getPatientCoach(userId: String, timestamp: String, borgUUID: String){
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.getPatientCoach(userId: userId, timestamp: timestamp, borgUUID: borgUUID).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientCoach(patientCoach: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }

    func getPatientSurvey(userId: String, timestamp: String){
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.getPatientSuvery(userId: userId, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientSurvey(patientSurvey: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }
    
    func getPatientBorg(userId: String, timestamp: String){
        self.delegate?.onStartLoadingHandle(handleType: .clearBackgroundAndCantTouchView)
        repository.getPatientBorg(userId: userId, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientBorg(patientBorg: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: disposeBag)
    }

}
