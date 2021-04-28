//
//  eq5dViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/2.
//

import Foundation
import UIKit

class eq5dViweController: UIViewController,  UITextFieldDelegate{
    @IBOutlet weak var q1Slider: UISlider!
    @IBOutlet weak var q2Slider: UISlider!
    @IBOutlet weak var q3Slider: UISlider!
    @IBOutlet weak var q4Slider: UISlider!
    @IBOutlet weak var q5Slider: UISlider!
    @IBOutlet weak var q1Ans: UILabel!
    @IBOutlet weak var q2Ans: UILabel!
    @IBOutlet weak var q3Ans: UILabel!
    @IBOutlet weak var q4Ans: UILabel!
    @IBOutlet weak var q5Ans: UILabel!
    @IBOutlet weak var vasValue: UITextField!
    
    
    @IBAction func q1Change(_ sender: UISlider) {
        sender.value.round()
        q1Ans.text = Int(sender.value).description
    }
    @IBAction func q2Change(_ sender: UISlider) {
        sender.value.round()
        q2Ans.text = Int(sender.value).description
    }
    @IBAction func q3Change(_ sender: UISlider) {
        sender.value.round()
        q3Ans.text = Int(sender.value).description
    }
    @IBAction func q4Change(_ sender: UISlider) {
        sender.value.round()
        q4Ans.text = Int(sender.value).description
    }
    @IBAction func q5Change(_ sender: UISlider) {
        sender.value.round()
        q5Ans.text = Int(sender.value).description
    }
    override func viewDidLoad() {
        vasValue.delegate = self
        vasValue.placeholder = "0-100分，越高則對生活越滿意"
        summitButton.isUserInteractionEnabled = false
    }
    var sumAry:[String] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func enter(_ sender: Any) {
        let oneText = q1Ans.text!
        let twoText = q2Ans.text!
        let thrText = q3Ans.text!
        let forText = q4Ans.text!
        let fivText = q5Ans.text!
        let vas = vasValue.text!
        sumAry = [oneText , twoText, thrText,forText, fivText]
        
        if (sumAry.contains("請滑動滑桿")) || (vas == ""){
            summitButton.isUserInteractionEnabled = false
        }else{
            summitButton.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var summitButton: UIButton!
    @IBAction func summit(_ sender: UIButton) {
        performSegue(withIdentifier: "summitEq5dSeque", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? quesViewController
        controller?.eq5Ary = sumAry
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        // 只允許輸入數字
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        // let expression = "^[0-9]*([0-9])?$" 只允許輸入數字
        // let expression = "^[A-Za-z0-9]+$" //允許輸入數字及字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
            let finishAlert = UIAlertController(title: "錯誤", message: "請輸入數字", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
            return false
        }
        return true
    }
}
