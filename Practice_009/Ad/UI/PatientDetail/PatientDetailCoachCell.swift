import UIKit

class PatientDetailCoachCell: UITableViewCell {
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.setBorder(width: 0, radius: 4, color: UIColor.lightGray)
        borderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)
    }
    
    func setPatientBorgAndCoach(data: PatientBorgAndCoach) {
        if let speed = data.speed {
            self.speed.text = "\(speed)"
        } else {
            self.speed.text = " "
        }
        
        if let time = data.time {
            self.time.text = "\(time)"
        } else {
            self.time.text = " "
        }
        
        self.timestamp.text = data.timestamp!
    }
    
    func setPatientCoach(data: PatientCoach.OuterData.Data) {
        if let speed = data.speed {
            self.speed.text = "\(speed)"
        } else {
            self.speed.text = " "
        }
        
        if let time = data.time {
            self.time.text = "\(time)"
        } else {
            self.time.text = " "
        }
        
        self.timestamp.text = data.timestamp!
    }
    
}
