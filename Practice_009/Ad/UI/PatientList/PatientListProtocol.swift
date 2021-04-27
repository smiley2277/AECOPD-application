import UIKit

protocol PatientListViewProtocol: BaseViewControllerProtocol {
    func onBindPatientList()
}

protocol PatientListPresenterProtocol: NSObjectProtocol {
    func getPatientList()
}
