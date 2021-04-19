import UIKit
import RxSwift

class PatientListRepository {
    static let shared = PatientListRepository()
    func getPatientList() -> Single<[String]> {
        let api = APIManager.shared.getPatientList()
        //TODO 待API，接上Model
        return api.map{ _ in ["TODO"] }
    }
}


