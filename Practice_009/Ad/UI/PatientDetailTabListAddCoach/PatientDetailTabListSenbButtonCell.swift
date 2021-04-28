//
//  PatientDetailTablListAddCoachCell.swift
//  Admin
//
//  Created by pekkapekka on 2021/4/12.
//

import Foundation
import UIKit

protocol PatientDetailTablListSendButtonCellProtocol: NSObjectProtocol {
    func onTouchSendButton()
}

class PatientDetailTablListSendButtonCell: UITableViewCell {
    
    @IBOutlet weak var sendButton: UIButton!
    weak var delegate: PatientDetailTablListSendButtonCellProtocol?
    
    override func awakeFromNib() {
        sendButton.layer.cornerRadius = 4
        sendButton.backgroundColor = UIColor.systemIndigo
        sendButton.tintColor = UIColor.white
        //sendButton.addTarget(self, action: #selector(onTouchSendButton), for: .touchUpInside)
    }
    
    @IBAction func onTouchSendButton(_ sender: Any) {
        delegate?.onTouchSendButton()
    }
}
