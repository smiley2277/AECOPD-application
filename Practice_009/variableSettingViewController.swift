//
//  variableSettingViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/13.
//

import Foundation
import UIKit

class variableSettingViewController: BaseViewController, UITextFieldDelegate{
    var userDefaults: UserDefaults!
    @IBOutlet weak var stepSize: UITextField!
    @IBOutlet weak var stepSizeDefault: UILabel!
    @IBOutlet weak var timeDefault: UILabel!
    @IBOutlet weak var durationDefault: UILabel!
    @IBOutlet weak var speedDefault: UILabel!
    @IBOutlet weak var speed1: UITextField!
    @IBOutlet weak var speed2: UITextField!
    @IBOutlet weak var speed3: UITextField!
    @IBOutlet weak var duration1: UITextField!
    @IBOutlet weak var duration2: UITextField!
    @IBOutlet weak var duration3: UITextField!
    var spe: [Float] = []
    var dur: [Int] = []
    // TODO: 多筆的建議
    override func viewDidLoad() {
        stepSize.delegate = self
        userDefaults = UserDefaults.standard
    }
    override func viewWillAppear(_ animated: Bool) {
        var stepSizeLabel = settingDefault(keyName: "stepSize")
        stepSizeDefault.text = String(lround((stepSizeLabel as! NSString).doubleValue))
        timeDefault.text = settingDefault(keyName: "stepCount")
        durationDefault.text = settingDefaultForAry(keyName: "durationV")?.map({ "\($0)" }).joined(separator: "-") ?? ""
        speedDefault.text = settingDefaultForFloatAry(keyName: "speedV")?.map({ "\($0)" }).joined(separator: "-") ?? ""
        let info_SPFD = settingDefaultForFloatAry(keyName: "speedVFromD")
        let info_DDFD = settingDefaultForAry(keyName: "durationVFromD")
        if (info_SPFD != []) && (info_DDFD != []){
            speedDefault.text = info_SPFD?.map({ "\($0)" }).joined(separator: "-") ?? ""
            durationDefault.text  = info_DDFD?.map({ "\($0)" }).joined(separator: "-") ?? ""
        }
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
        if (speed1.text != "") && (duration1.text != ""){
            spe.append(Float((speed1.text as! NSString).intValue))
            dur.append(Int((duration1.text as! NSString).intValue))
        }
        if (speed2.text != "") && (duration2.text != ""){
            spe.append(Float((speed2.text as! NSString).intValue))
            dur.append(Int((duration2.text as! NSString).intValue))
        }
        if (speed3.text != "") && (duration3.text != ""){
            spe.append(Float((speed3.text as! NSString).intValue))
            dur.append(Int((duration3.text as! NSString).intValue))
        }
        if (spe.count != 0) && (dur.count != 0){
            userDefaults.set(spe, forKey: "speedV")
            userDefaults.set(dur, forKey: "durationV")
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
    func settingDefaultForAry(keyName: String)->[Int]?{
        var defaults: [Int] = []
        if (keyName == "durationV"){
            defaults = UserDefaults.standard.array(forKey: keyName)as? [Int] ?? [Int]()
        }else if (keyName == "durationVFromD"){
            defaults = UserDefaults.standard.array(forKey: keyName)as? [Int] ?? [Int]()
        }
        return defaults
    }
    func settingDefaultForFloatAry(keyName: String)->[Float]?{
        var defaults: [Float] = []
        if (keyName == "speedV"){
            defaults = UserDefaults.standard.array(forKey: keyName)as? [Float] ?? [Float]()
        }else if (keyName == "speedVFromD"){
            defaults = UserDefaults.standard.array(forKey: keyName)as? [Float] ?? [Float]()
        }
        return defaults
        
    }
}
