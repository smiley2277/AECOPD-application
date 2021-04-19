import UIKit

class PatientDetailEmptyCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.setBorder(width: 0, radius: 4, color: UIColor.lightGray)
        borderView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4)
    }
    
}
