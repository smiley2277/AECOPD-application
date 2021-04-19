//
//  stepSizeViewController.swift
//  Practice_009
//  填寫十公尺走幾步的..
//  Created by 鄭郁潔 on 2021/4/9.
//

import Foundation
import UIKit

class stepSizeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var stepSize: UITextField!
    let notificationName = Notification.Name("sendStepsizeByFill")
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        // 只允許輸入數字
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
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
    
    
    @IBAction func save(_ sender: UIButton) {
        performSegue(withIdentifier: "stepSizeUnwindSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stepsize = stepSize.text!
        var stepSize = (stepsize as NSString).doubleValue
        stepSize = (1/stepSize) * 1000
        let controller = segue.destination as? smartCoachListViewController
        controller?.stepSize = stepSize
    }
    
}
