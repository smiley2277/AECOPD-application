import UIKit

class PatientDetailSurveyCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var cat1: UILabel!
    @IBOutlet weak var cat2: UILabel!
    @IBOutlet weak var cat3: UILabel!
    @IBOutlet weak var cat4: UILabel!
    @IBOutlet weak var cat5: UILabel!
    @IBOutlet weak var cat6: UILabel!
    @IBOutlet weak var cat7: UILabel!
    @IBOutlet weak var cat8: UILabel!
    @IBOutlet weak var catsum: UILabel!
    @IBOutlet weak var eq1: UILabel!
    @IBOutlet weak var eq2: UILabel!
    @IBOutlet weak var eq3: UILabel!
    @IBOutlet weak var eq4: UILabel!
    @IBOutlet weak var eq5: UILabel!
    @IBOutlet weak var mmrc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.setBorder(width: 0, radius: 4, color: UIColor.lightGray)
        borderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)
    }
    
    func setPatientSurvey(data: PatientSurvey.OuterData.Data) {
        self.timestamp.text = "\(data.timestamp!)"
        self.cat1.text = "\(data.cat1!)"
        self.cat2.text = "\(data.cat2!)"
        self.cat3.text = "\(data.cat3!)"
        self.cat4.text = "\(data.cat4!)"
        self.cat5.text = "\(data.cat5!)"
        self.cat6.text = "\(data.cat6!)"
        self.cat7.text = "\(data.cat7!)"
        self.cat8.text = "\(data.cat8!)"
        self.catsum.text = "\(data.catsum!)"
        self.eq1.text = "\(data.eq1!)"
        self.eq2.text = "\(data.eq2!)"
        self.eq3.text = "\(data.eq3!)"
        self.eq4.text = "\(data.eq4!)"
        self.eq5.text = "\(data.eq5!)"
        self.mmrc.text = "\(data.mmrc!)"
    }
    
}
