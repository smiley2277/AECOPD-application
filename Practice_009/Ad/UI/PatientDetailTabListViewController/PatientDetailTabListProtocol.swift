import UIKit

protocol PatientDetailTabListViewProtocol: BaseViewControllerProtocol {
    func onBindPatientSurvey(patientSurvey: PatientSurvey)
    func onBindPatientCoach(patientCoach: PatientCoach)
    func onBindPatientBorg(patientBorg: PatientBorg)
    func onBindPostPatientCoachResponse(postPatientCoachResponse: PostPatientCoachResponse)
}

protocol PatientDetailTabListPresenterProtocol: NSObjectProtocol {
    func postPatientCoach(userId: String, timeStamp: String, borgUUID: String, patientCoachList: [(speed: Int?, time: Int?)])
    func getPatientSurvey(userId: String, timestamp: String)
    func getPatientCoach(userId: String, timestamp: String, borgUUID: String)
    func getPatientBorg(userId: String, timestamp: String)
}
