import UIKit

protocol PatientListCellProtocol: NSObjectProtocol {
    func onTouchPatientListCell(patientName: String, row: Int)
}

class PatientListCell: UITableViewCell {
    @IBOutlet weak var patientNameButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    private var patientName: String?
    private var row: Int?
    weak var delegate: PatientListCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setPatientName(patientName: String, row: Int){
        self.patientNameButton.setTitle(patientName, for: .normal)
        self.patientName = patientName
        self.row = row
    }
    
    @IBAction func onTouchPatientButton(_ sender: Any) {
        delegate?.onTouchPatientListCell(patientName: patientName!, row: row!)
    }
}
