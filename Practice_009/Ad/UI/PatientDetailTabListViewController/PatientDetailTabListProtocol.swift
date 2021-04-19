import UIKit

protocol PatientDetailTabListViewProtocol: NSObjectProtocol {
    func onBindPatientSurvey(patientSurvey: PatientSurvey)
    func onBindPatientCoach(patientCoach: PatientCoach)
    func onBindPatientBorg(patientBorg: PatientBorg)
    func onBindPostPatientCoachResponse(postPatientCoachResponse: PostPatientCoachResponse)
}

protocol PatientDetailTabListPresenterProtocol: NSObjectProtocol {
    func postPatientCoach(userId: String, timeStamp: String, speed: String, time: String)
    func getPatientSurvey(userId: String, timestamp: String)
    func getPatientCoach(userId: String, timestamp: String)
    func getPatientBorg(userId: String, timestamp: String)
}
