//
//  PatientDetailTablListAddCoachCell.swift
//  Admin
//
//  Created by pekkapekka on 2021/4/12.
//

import Foundation
import UIKit

extension PatientDetailTabListInputCell {
    func setCell(title: String, suggestSpeed: Int?, suggestTime: Int?, isAddCoachButtonHidden: Bool, index: Int){
        self.title.text = title
        
        if let speed = suggestSpeed {
            self.suggestSpeed.text = "\(speed)"
        } else {
            self.suggestSpeed.text = ""
        }
        
        if let time = suggestTime {
            self.suggestTime.text = "\(time)"
        } else {
            self.suggestTime.text = ""
        }
        
        self.addCoachCountButton.isHidden = isAddCoachButtonHidden
        self.index = index
    
    }
    
    func setIndex(_ index: Int) {
        self.index = index
    }
}

protocol PatientDetailTabListInputCellProtocol: NSObjectProtocol {
    func onTouchAddCoachCountButton()
    func onTypeSpeedTime(speed: Int?, time: Int?, index: Int)
    func onTextFieldDidBeginEditing(index: Int)
    func onTextFieldDidEndEditing()
}

class PatientDetailTabListInputCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var suggestSpeed: UITextField!
    @IBOutlet weak var suggestTime: UITextField!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var addCoachCountButton: UIButton!
    weak var delegate: PatientDetailTabListInputCellProtocol?
    var isFilled: Bool {
        return suggestSpeed.text != "" && suggestTime.text != ""
    }
    private var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        suggestTime.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        suggestSpeed.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        suggestTime.delegate = self
        suggestSpeed.delegate = self
    }
    
    func setBecomeFirstResponder(){
        //MARK: 自動跳到尚未填寫的欄位，如果都填了，跳第一個
        if suggestSpeed.text == "" {
            suggestSpeed.becomeFirstResponder()
        } else if suggestTime.text == "" {
            suggestTime.becomeFirstResponder()
        } else {
            suggestSpeed.becomeFirstResponder()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onTextFieldDidBeginEditing(index: index!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onTextFieldDidEndEditing()
    }
    
    @IBAction func onTouchAddCoachCountButton() {
        delegate?.onTouchAddCoachCountButton()
    }

}

extension PatientDetailTabListInputCell {
    @objc func textDidChange() {
        
        var speed: Int?
        var time: Int?
        
        if suggestSpeed?.text == "" {
            speed = nil
        } else {
            speed = Int(suggestSpeed.text!)
        }
        
        if suggestTime?.text == "" {
            time = nil
        } else {
            time = Int(suggestTime.text!)
        }
        
        delegate?.onTypeSpeedTime(speed: speed, time: time, index: index!)
    }
}
