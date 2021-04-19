import UIKit

protocol PatientListViewProtocol: NSObjectProtocol {
    func onBindPatientList()
}

protocol PatientListPresenterProtocol: NSObjectProtocol {
    func getPatientList()
}
