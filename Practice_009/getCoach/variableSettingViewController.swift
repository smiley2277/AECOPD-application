//
//  variableSettingViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/13.
//

import Foundation
import UIKit

class variableSettingViewController: UIViewController, UITextFieldDelegate{
    var userDefaults: UserDefaults!
    @IBOutlet weak var stepSize: UITextField!
    @IBOutlet weak var stepSizeDefault: UILabel!
    @IBOutlet weak var timeDefault: UILabel!
    // TODO: 多筆的建議
    override func viewDidLoad() {
        stepSize.delegate = self
        userDefaults = UserDefaults.standard
    }
    override func viewWillAppear(_ animated: Bool) {
        var stepSizeLabel = settingDefault(keyName: "stepSize")
        stepSizeDefault.text = String(lround((stepSizeLabel as! NSString).doubleValue))
        timeDefault.text = settingDefault(keyName: "stepCount")
    }
    //textField delegation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        // 只允許輸入數字
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress, range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
            let finishAlert = UIAlertController(title: "錯誤", message: "請輸入數字", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //傳值
    @IBAction func summit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "variableSpeedViewController") as! variableSpeedViewController
        if (stepSize.text != "") || (vc.stepSize == 0){
            let stepsize = stepSize.text!
            var stepSize = (stepsize as NSString).doubleValue
            stepSize = (1/stepSize) * 1000
            vc.setStepSize(size: stepSize)
            userDefaults.set(stepsize, forKey: "stepCount")
            userDefaults.set(stepSize, forKey: "stepSize")
//            print("@VSVC, stepCOunt", stepsize)
            userDefaults.synchronize()
        }
        performSegue(withIdentifier: "variableSettingUnwindSegue", sender: self)
    }
    //存取預設值
    func settingDefault(keyName: String)->String?{
        var defaults:String?
        if (keyName == "stepSize"){
             defaults = String(UserDefaults.standard.double(forKey: keyName))
        }else if(keyName == "stepCount"){
            defaults = String(UserDefaults.standard.integer(forKey: keyName))
        }
        return defaults
    }
}
