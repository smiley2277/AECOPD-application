import RxSwift

class PatientDetailTabListRepository {
    static let shared = PatientDetailTabListRepository()
    
    func postPatientCoach(userId: String, timestamp: String, speed: String, time: String) -> Single<PostPatientCoachResponse> {
        let api = APIManager.shared.postPatientCoach(userId: userId, timestamp: timestamp, speed: speed, time: time)
        return LoginRepository.shared.authorization
            .flatMap({_ in api})
            .map{ PostPatientCoachResponse(JSON: $0)! }
    }
    
    func getPatientCoach(userId: String, timestamp: String) -> Single<PatientCoach> {
        let api = APIManager.shared.getPatientCoach(userId: userId, timestamp: timestamp)
        return LoginRepository.shared.authorization
            .flatMap({_ in api})
            .map{ PatientCoach(JSON: $0)! }
    }
    
    func getPatientSuvery(userId: String, timestamp: String) -> Single<PatientSurvey> {
        let api = APIManager.shared.getPatientSurvey(userId: userId, timestamp: timestamp)
        return api.map{ PatientSurvey(JSON: $0)! }
    }
    
    func getPatientBorg(userId: String, timestamp: String) -> Single<PatientBorg> {
        let api = APIManager.shared.getPatientBorg(userId: userId, timestamp: timestamp)
        return api.map{ PatientBorg(JSON: $0)! }
    }
}


