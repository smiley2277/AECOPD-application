import UIKit

extension PatientDetailViewController {
    func setIsShowSurvey(_ isShow: Bool) {
        self.isShowSurvey = isShow
    }
    
    func setIsShowCoach(_ isShow: Bool) {
        self.isShowCoach = isShow
    }
    
    func setIsShowBorg(_ isShow: Bool) {
        self.isShowBorg = isShow
    }
    
    func setPatientSurvey(_ patientSurvey: PatientSurvey?) {
        self.patientSurvey = patientSurvey
        tableView.reloadData()
    }
    
    func setPatientBorgAndCoachList(_ patientBorgAndCoachList: [PatientBorgAndCoach]) {
        self.patientBorgAndCoachList = patientBorgAndCoachList
        tableView.reloadData()
    }
}

class PatientDetailViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    private var isShowSurvey: Bool = true
    private var isShowCoach: Bool = true
    private var isShowBorg: Bool = true
    
    private var patientSurvey: PatientSurvey?
    private var patientBorgAndCoachList: [PatientBorgAndCoach] = []
    
    private var originY: CGFloat?
    
    enum Section: Int, CaseIterable {
        case emptyHint = 0
        case survey
        case borg
        case coach
        case borgAndCoach
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .custom)
        self.setNavType(navBarType: .notHidden)
        self.setIsNavShadowEnable(false)
    }

}

extension PatientDetailViewController: UITableViewDelegate {
    
}

extension PatientDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .emptyHint:
            var isEmpty = true
            if isShowSurvey && (patientSurvey?.data?.data.isEmpty ?? true) == false { isEmpty = false }
            if isShowBorg && (patientBorgAndCoachList.isEmpty) == false { isEmpty = false }
            if isShowCoach && (patientBorgAndCoachList.isEmpty) == false { isEmpty = false }
            return isEmpty ? 1 : 0
        case .survey:
            if isShowSurvey == false { return 0 }
            return patientSurvey?.data?.data.count ?? 0
        case .borg:
            return 0
            
        case .coach:
            return 0

        case .borgAndCoach:
            return patientBorgAndCoachList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .emptyHint:
            return tableView.dequeueReusableCell(withIdentifier: "Empty")!
        case .survey:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Survey")! as! PatientDetailSurveyCell
            cell.setPatientSurvey(data: self.patientSurvey!.data!.data[indexPath.row])
            return cell
        case .borg:
            return PatientDetailBorgCell()
        case .coach:
            return PatientDetailCoachCell()
        case .borgAndCoach:
            if patientBorgAndCoachList[indexPath.row].isBorg {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Borg")! as! PatientDetailBorgCell
                cell.setPatientBorgAndCoach(data: patientBorgAndCoachList[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Coach")! as! PatientDetailCoachCell
                cell.setPatientBorgAndCoach(data: patientBorgAndCoachList[indexPath.row])
                return cell
            }
        }
    }
}

extension PatientDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}


