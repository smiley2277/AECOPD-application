import UIKit

extension UIView {
    func setBorder(width:CGFloat,radius:CGFloat,color:UIColor?){
        self.layer.cornerRadius = radius
        self.layer.borderWidth  = width
        
        if let borderColor = color{
            self.layer.borderColor  = borderColor.cgColor
        }
    }
    
    func removeBorder(){
        self.layer.cornerRadius = 0
        self.layer.borderWidth  = 0
        self.layer.borderColor  = self.backgroundColor?.cgColor
    }
    
    func setButtonDefaultBorder(){
        self.layer.cornerRadius = 4
        self.layer.borderWidth  = 0
        self.layer.borderColor  = UIColor.white.cgColor
    }
    
    func setCircleView(borderWidth:CGFloat,color:UIColor?){
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        if let borderColor = color{
            self.layer.borderColor  = borderColor.cgColor
        }
    }
    
    func setShadow(offset:CGSize,opacity:Float,shadowRadius:CGFloat) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setShadow(offset:CGSize,opacity:Float,shadowRadius:CGFloat, color: UIColor) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
            }
        }
    }
}
