//
//  signUpToBackendViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/21.
//

import Foundation
import UIKit
import SwiftUI
import Alamofire

class signUpToBackendViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var summitBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bDayFill: UITextField!
    @IBOutlet weak var lastNameFill: UITextField!
    @IBOutlet weak var firstNameFill: UITextField!
    @IBOutlet weak var ageFill: UITextField!
    @IBOutlet weak var emailFill: UITextField!
    @IBOutlet weak var heightFill: UITextField!
    @IBOutlet weak var weightFill: UITextField!
    @IBOutlet weak var phoneFill: UITextField!
    @IBOutlet weak var IDFill: UITextField!
    @IBOutlet weak var passwordFill: UITextField!
    @IBOutlet weak var checkpwFill: UITextField!
    @IBOutlet weak var useridFill: UITextField!
    var user_id: String = ""
    weak var delegate: LoginViewControllerProtocol?
    
    private var presenter: signUpToBackendPresenterProtocol?
    var sexuality: String = ""
    let formatter = DateFormatter()
    var receiveData: [String:Any] = [:]
    @IBAction func sexualitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            sexuality = "Female"
        }else{
            sexuality = "Male"
        }
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneSelect))
        toolbar.setItems([doneBtn], animated: true)
        bDayFill.inputAccessoryView = toolbar
        bDayFill.inputView = datePicker
    }
    @objc func doneSelect(){
        formatter.dateFormat = "yyyy-MM-dd"
        bDayFill.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    private func enableSignUpButton(_ isEnable: Bool) {
        summitBtn.alpha = isEnable ? 1 : 0.5
        summitBtn.isUserInteractionEnabled = isEnable
    }
    private func clearTextField() {
        ageFill.text = ""
        heightFill.text = ""
        weightFill.text = ""
        lastNameFill.text = ""
        firstNameFill.text = ""
        emailFill.text = ""
        bDayFill.text = ""
        phoneFill.text = ""
        IDFill.text = ""
        passwordFill.text = ""
        checkpwFill.text = ""
        useridFill.text = ""
    }
    @IBAction func send(_ sender: Any) {
        if bDayFill.text == "" || bDayFill.text == nil { return }
        if lastNameFill.text == "" || lastNameFill.text == nil { return }
        if firstNameFill.text == "" || firstNameFill.text == nil { return }
        if ageFill.text == "" || ageFill.text == nil { return }
        if emailFill.text == "" || emailFill.text == nil { return }
        if heightFill.text == "" || heightFill.text == nil { return }
        if weightFill.text == "" || weightFill.text == nil { return }
        if phoneFill.text == "" || phoneFill.text == nil { return }
        if IDFill.text == "" || IDFill.text == nil { return }
        if passwordFill.text == "" || passwordFill.text == nil { return }
        if (passwordFill.text != checkpwFill.text){
            let finishAlert = UIAlertController(title: "提醒", message: "密碼填寫有誤，請填寫相同密碼", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(finishAlert, animated: true)
        }else{
            if (useridFill.text != nil){
                user_id = useridFill.text!
            }else{
                user_id = ""
            }
            let age = Int((ageFill.text ?? "0") as String)!
            let height = Int((heightFill.text ?? "0") as String)!
            let weight = Float((weightFill.text ?? "0") as String)!
            presenter?.getSignUpResult(lastname: lastNameFill.text!, firstname: firstNameFill.text!, age: age, email: emailFill.text!, birthday: bDayFill.text!, gender: sexuality, height: height, weight: Int(weight), phone: phoneFill.text!, identity: IDFill.text!, password: passwordFill.text!)
        }
        clearTextField()
    }
    override func viewDidLoad() {
        presenter = signUpToBackendPresenter(delegate: self)
        lastNameFill.delegate = self
        firstNameFill.delegate = self
        ageFill.delegate = self
        emailFill.delegate = self
        heightFill.delegate = self
        weightFill.delegate = self
        phoneFill.delegate = self
        IDFill.delegate = self
        passwordFill.delegate = self
        checkpwFill.delegate = self
        useridFill.delegate = self
        datePicker.date = NSDate() as Date
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        createDatePicker()
        lastNameFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        firstNameFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        ageFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        heightFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        weightFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        phoneFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        IDFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        checkpwFill.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        enableSignUpButton(false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func enableSignUpErrorHint(_ isEnable: Bool) {
        let finishAlert = UIAlertController(title: "提醒", message: "請確認都有填到唷", preferredStyle: .alert)
        finishAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
        self.present(finishAlert, animated: true)
    }
}

extension signUpToBackendViewController: signUpToBackendViewProtocol {
    func onBindSignUpResult(SignUpResult: LoginResult) {
        delegate?.onSignUpSuccess(loginResult: SignUpResult)
        navigationController?.popViewController(animated: true)
    }
}

extension signUpToBackendViewController {
    @objc func textDidChange() {
        let isFilled = !(ageFill.text == "" || heightFill.text == "" || weightFill.text == "" || lastNameFill.text == "" || firstNameFill.text == "" || emailFill.text == "" || bDayFill.text == "" || phoneFill.text == "" || IDFill.text == "" || passwordFill.text == "" || checkpwFill.text == "")
        enableSignUpButton(isFilled)
    }
}
