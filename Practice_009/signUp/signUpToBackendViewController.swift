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
    let VCstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var vc: ViewController {
        get {
         return VCstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        }
    }
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
    
    @IBAction func checkAge(_ sender: UITextField) {
        let newString = (ageFill.text! as NSString).replacingCharacters(in: NSMakeRange(0, ageFill.text!.count), with: ageFill.text!)
        // 只允許輸入數字
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
            vc.alert(title: "錯誤", msg: "請輸入數字", btn: "確定")
            ageFill.text = ""
        }
    }
    @IBAction func checkEmail(_ sender: Any) {
        let newString = (emailFill.text! as NSString).replacingCharacters(in: NSMakeRange(0, emailFill.text!.count), with: emailFill.text!)
        if  !(newString.contains("@")){
            vc.alert(title: "錯誤", msg: "請輸入電子郵件正式格式", btn: "確定")
            emailFill.text = ""
        }
    }
    @IBAction func checkID(_ sender: Any) {
        let newString = (IDFill.text! as NSString).replacingCharacters(in: NSMakeRange(0, IDFill.text!.count), with: IDFill.text!)
        
        let expression =  "[A-Z]{1}[0-9]{9}"
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
            vc.alert(title: "錯誤", msg: "請輸入台灣身分證字號格式", btn: "確定")
            IDFill.text = ""
        }
    }
    @IBAction func send(_ sender: Any) {
        if bDayFill.text == "" || bDayFill.text == nil { return }
        if lastNameFill.text == "" || lastNameFill.text == nil { return }
        if firstNameFill.text == "" || firstNameFill.text == nil { return }
        if emailFill.text == "" || emailFill.text == nil { return }
        if heightFill.text == "" || heightFill.text == nil { return }
        if weightFill.text == "" || weightFill.text == nil { return }
        if phoneFill.text == "" || phoneFill.text == nil { return }
        if IDFill.text == "" || IDFill.text == nil { return }
        if passwordFill.text == "" || passwordFill.text == nil { return }
        if (passwordFill.text != checkpwFill.text){
            vc.alert(title: "提醒", msg: "密碼填寫有誤，請填寫相同密碼", btn: "確定")
        }else{
            if (useridFill.text != nil){
                user_id = useridFill.text!
            }else{
                user_id = ""
            }
            let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
            let age = gregorian?.components([.month, .day, .year], from: datePicker.date, to: Date(), options:[])
            let height = Int((heightFill.text ?? "0") as String)!
            let weight = Float((weightFill.text ?? "0") as String)!
            presenter?.getSignUpResult(lastname: lastNameFill.text!, firstname: firstNameFill.text!, age: (age?.year) ?? 18, email: emailFill.text!, birthday: bDayFill.text!, gender: sexuality, height: height, weight: Int(weight), phone: phoneFill.text!, identity: IDFill.text!, password: passwordFill.text!)
        }
        clearTextField()
    }
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
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
        passwordFill.isSecureTextEntry = true
        checkpwFill.isSecureTextEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func enableSignUpErrorHint(_ isEnable: Bool) {
        vc.alert(title: "提醒", msg: "請確認都有填到唷", btn: "確定")
    }
    @IBOutlet weak var scrollview: UIScrollView!
    @objc func keyboardWillShow(_ notification:Notification){
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(notification: NSNotification){
        let contentInsets = UIEdgeInsets.zero
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        let isFilled = !(heightFill.text == "" || weightFill.text == "" || lastNameFill.text == "" || firstNameFill.text == "" || emailFill.text == "" || bDayFill.text == "" || phoneFill.text == "" || IDFill.text == "" || passwordFill.text == "" || checkpwFill.text == "")
        enableSignUpButton(isFilled)
    }
}
