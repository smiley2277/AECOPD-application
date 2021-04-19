import UIKit

class PatientDetailBorgCell: UITableViewCell {
    @IBOutlet weak var preborg: UILabel!
    @IBOutlet weak var postborg: UILabel!
    @IBOutlet weak var prebeat: UILabel!
    @IBOutlet weak var postbeat: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.setBorder(width: 0, radius: 4, color: UIColor.lightGray)
        borderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)
    }
    
    func setPatientBorgAndCoach(data: PatientBorgAndCoach) {
        if let preborg = data.preborg {
            self.preborg.text = "\(preborg)"
        } else {
            self.preborg.text = " "
        }
        
        if let postborg = data.postborg {
            self.postborg.text = "\(postborg)"
        } else {
            self.postborg.text = " "
        }
        
        if let prebeat = data.prebeat {
            self.prebeat.text = "\(prebeat)"
        } else {
            self.prebeat.text = " "
        }
        
        if let postbeat = data.postbeat {
            self.postbeat.text = "\(postbeat)"
        } else {
            self.postbeat.text = " "
        }
        
        self.timestamp.text = data.timestamp!
    }
    
    func setPatientBorg(data: PatientBorg.OuterData.Data) {

        if let preborg = data.preborg {
            self.preborg.text = "\(preborg)"
        } else {
            self.preborg.text = " "
        }
        
        if let postborg = data.postborg {
            self.postborg.text = "\(postborg)"
        } else {
            self.postborg.text = " "
        }
        
        if let prebeat = data.prebeat {
            self.prebeat.text = "\(prebeat)"
        } else {
            self.prebeat.text = " "
        }
        
        if let postbeat = data.postbeat {
            self.postbeat.text = "\(postbeat)"
        } else {
            self.postbeat.text = " "
        }
        
        self.timestamp.text = data.timestamp!
    }
    
}
