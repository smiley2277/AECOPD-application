//
//  speedDurationViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/11.
//

import Foundation
import UIKit

class speedDurationViewController: BaseViewController, UITextFieldDelegate {
    var userDefaults: UserDefaults!
    @IBOutlet weak var durationFill: UITextField!
    @IBOutlet weak var speedFill: UITextField!
    @IBOutlet weak var stepSize: UITextField!
    @IBOutlet weak var speedDefault: UILabel!
    @IBOutlet weak var stepSizeDefault: UILabel!
    @IBOutlet weak var timeDefault: UILabel!
    @IBOutlet weak var stepCountDefault: UILabel!
    
    override func viewDidLoad() {
        durationFill.delegate = self
        speedFill.delegate = self
        stepSize.delegate = self
        userDefaults = UserDefaults.standard
    }
    override func viewWillAppear(_ animated: Bool) {
        let info_SFD = settingDefault(keyName: "speedFromD")
        let info_DFD = settingDefault(keyName: "durationFromD")
        if (info_SFD != "0") && (info_DFD != "0"){
            speedDefault.text = info_SFD
            timeDefault.text = info_DFD
        }else{
            speedDefault.text = settingDefault(keyName: "speed")
            timeDefault.text = settingDefault(keyName: "duration")
        }
        stepCountDefault.text = settingDefault(keyName: "stepCount")
        var stepSizeLabel = settingDefault(keyName: "stepSize")
        stepSizeDefault.text = String(lround((stepSizeLabel as! NSString).doubleValue))
        
    }
    //textField delegation
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
        let vc = storyboard.instantiateViewController(withIdentifier: "walkingTestViewController") as! walkingTestViewController
        if (speedFill.text != "") || (durationFill.text != ""){
            if (speedFill.text != "") && (durationFill.text != ""){
                let spe = (speedFill.text! as NSString).floatValue
                let dur = Int(durationFill.text!)!
                userDefaults.set(spe, forKey: "speed")
                userDefaults.set(dur, forKey: "duration")
                userDefaults.synchronize()
            }else if (durationFill.text != ""){
                let dur = Int(durationFill.text!)!
                userDefaults.set(dur, forKey: "duration")
                userDefaults.synchronize()
            }else if (speedFill.text != ""){
                let spe = (speedFill.text! as NSString).floatValue
                userDefaults.set(spe, forKey: "speed")
                userDefaults.synchronize()
            }
        }
        if (stepSize.text != "") && (vc.stepSize == 0){
            let stepsize = stepSize.text!
            var stepSize = (stepsize as NSString).doubleValue
            stepSize = (1/stepSize) * 1000
            vc.setStepSize(size: stepSize)
            userDefaults.set(stepsize, forKey: "stepCount")
            userDefaults.set(stepSize, forKey: "stepSize")
            userDefaults.synchronize()
        }
        
        
        performSegue(withIdentifier: "settingUnwindSegue", sender: self)
    }
    //存取預設值
    func settingDefault(keyName: String)->String?{
        var defaults:String?
        if (keyName == "stepSize"){
             defaults = String(UserDefaults.standard.double(forKey: keyName))
        }else if (keyName == "speed"){
             defaults = String(UserDefaults.standard.float(forKey: keyName))
        }else if (keyName == "duration"){
             defaults = String(UserDefaults.standard.integer(forKey: keyName))
        }else if (keyName == "stepCount"){
            defaults = String(UserDefaults.standard.integer(forKey: keyName))
        }else if (keyName == "speedFromD"){
            defaults = String(UserDefaults.standard.float(forKey: keyName))
        }else if (keyName == "durationFromD"){
            defaults = String(UserDefaults.standard.integer(forKey: keyName))
        }
        return defaults
    }
}
