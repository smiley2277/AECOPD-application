import UIKit
import RxSwift

class PatientListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var patients: [String] = ["test_id", "test_id2", "test_id3"]
    var presenter: PatientListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter =  PatientListPresenter(delegate: self)
        //TODO 待API
        //presenter?.getPatientList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PatientListCell", bundle: nil), forCellReuseIdentifier: "PatientListCell")

        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
    }

}

extension PatientListViewController: PatientListViewProtocol {
    func onBindPatientList() {
        //TODO 待API
        tableView.reloadData()
    }
}

extension PatientListViewController: PatientListCellProtocol {
    func onTouchPatientListCell(patientName: String, row: Int) {
        let storyboard = UIStoryboard(name: "PatientDetailTabList", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientDetailTabListViewController") as! PatientDetailTabListViewController
        vc.setUserId(userId: patients[row])
        self.navigationController?.pushViewController(vc, animated: true)
   
    }
}

extension PatientListViewController: UITableViewDelegate {

}
 
extension PatientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientListCell") as! PatientListCell
        cell.setPatientName(patientName: patients[indexPath.row], row: indexPath.row)
        cell.delegate = self
        return cell
    }
}
