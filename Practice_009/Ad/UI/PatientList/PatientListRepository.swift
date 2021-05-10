import UIKit
import RxSwift

class PatientListRepository {
    static let shared = PatientListRepository()
    func getGroupAdmin() -> Single<GroupAdmin> {
        let api = APIManager.shared.getGroupAdmin()
        return LoginRepository.shared.localAuthorizationData
            .flatMap({_ in api})
            .map{ GroupAdmin(JSON: $0)! }
    }
}


