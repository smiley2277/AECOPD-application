//
//  PatientDetailTablListAddCoachCell.swift
//  Admin
//
//  Created by pekkapekka on 2021/4/12.
//

import Foundation
import UIKit

class PatientDetailTabListTitleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    func setCell(title: String){
        self.title.text = title
    }
}
