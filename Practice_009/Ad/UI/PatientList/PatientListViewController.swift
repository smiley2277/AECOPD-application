import UIKit
import RxSwift

class PatientListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: PatientListPresenterProtocol?
    var userMembers: [GroupAdmin.OuterData.Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter =  PatientListPresenter(delegate: self)

        presenter?.getGroupAdmin()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PatientListCell", bundle: nil), forCellReuseIdentifier: "PatientListCell")

        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
    }

}

extension PatientListViewController: PatientListViewProtocol {
    func onBindGroupAdmin(groupAdmin: GroupAdmin) {
        userMembers = groupAdmin.data?.member.filter({ $0.roles == .user }) ?? []
        tableView.reloadData()
    }
}

extension PatientListViewController: PatientListCellProtocol {
    func onTouchPatientListCell(patientName: String, row: Int) {
        let storyboard = UIStoryboard(name: "PatientDetailTabList", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientDetailTabListViewController") as! PatientDetailTabListViewController
        let patientName = "\(userMembers[row].lastName ?? "")\(userMembers[row].firstName ?? "")"
        vc.setUserId(userId: userMembers[row].userID!, patientName: patientName, identity: userMembers[row].identity!)
        self.navigationController?.pushViewController(vc, animated: true)
   
    }
}

extension PatientListViewController: UITableViewDelegate {

}
 
extension PatientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientListCell") as! PatientListCell
        let patientName = "\(userMembers[indexPath.row].lastName ?? "")\(userMembers[indexPath.row].firstName ?? "")"
        cell.setPatientName(patientName: patientName, identity: userMembers[indexPath.row].identity!, row: indexPath.row)
        cell.delegate = self
        return cell
    }
}
