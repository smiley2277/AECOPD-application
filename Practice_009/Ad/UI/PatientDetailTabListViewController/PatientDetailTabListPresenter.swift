import RxSwift

class PatientDetailTabListPresenter: NSObject, PatientDetailTabListPresenterProtocol {
    weak var delegate: PatientDetailTabListViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    let repository = PatientDetailTabListRepository.shared
    
    required init(delegate: PatientDetailTabListViewProtocol) {
        self.delegate = delegate
    }

    //TODO
    func postPatientCoach(userId: String, timeStamp: String, borgUUID: String, patientCoachList: [(speed: Int?, time: Int?)]){
        repository.postPatientCoach(userId: userId, timestamp: timeStamp, borgUUID: borgUUID, patientCoachList: patientCoachList).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPostPatientCoachResponse(postPatientCoachResponse: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
    
    func getPatientCoach(userId: String, timestamp: String, borgUUID: String){
        repository.getPatientCoach(userId: userId, timestamp: timestamp, borgUUID: borgUUID).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientCoach(patientCoach: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }

    func getPatientSurvey(userId: String, timestamp: String){
        repository.getPatientSuvery(userId: userId, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientSurvey(patientSurvey: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }
    
    func getPatientBorg(userId: String, timestamp: String){
        repository.getPatientBorg(userId: userId, timestamp: timestamp).subscribe(onSuccess:{ (model) in
            self.delegate?.onBindPatientBorg(patientBorg: model)
        }, onError: {error in
            self.delegate?.onApiError(error: error as! APIError)
        }).disposed(by: disposeBag)
    }

}
