import UIKit

protocol PatientListViewProtocol: BaseViewControllerProtocol {
    func onBindGroupAdmin(groupAdmin: GroupAdmin)
}

protocol PatientListPresenterProtocol: NSObjectProtocol {
    func getGroupAdmin()
}
