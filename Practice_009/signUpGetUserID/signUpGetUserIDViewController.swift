//
//  signUpGetUserIDViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//

import Foundation
import UIKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class signUpGetUserIDViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var pwFIll: UITextField!
    @IBOutlet weak var emailFill: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var  userID: String = ""
    weak var delegate: LoginViewControllerProtocol?
    private var presenter: signUpGetUserIDPresenterProtocol?
    @IBAction func send(_ sender: Any) {
        if (pwFIll.text != "") && (emailFill.text != ""){
//            presenter?.getUserID(email: emailFill.text!, password: pwFIll.text!)
            var semaphore = DispatchSemaphore (value: 0)
            let parameters = "email="+emailFill.text!+"&password="+pwFIll.text!
            let postData =  parameters.data(using: .utf8)
            var request = URLRequest(url: URL(string: "https://ntu-med-god.ml/api/getUserIdByEmail")!,timeoutInterval: Double.infinity)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("connect.sid=s%3AwhglgQ34pjzKs99VdxF6IhBs98jg9yqt.e5ld3vZo6jPZ3AS2vXiKhvhEYsTtmy2u8G8zrMtKBoE", forHTTPHeaderField: "Cookie")
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
              }
                var userData = String(data: data, encoding: .utf8)!
                var userComp = userData.components(separatedBy: ":")
                for i in (0...userComp.count-1){
                    var j = userComp[i].replacingOccurrences(of: "\"", with: "")
                    j = j.replacingOccurrences(of: "{", with: "")
                    j = j.replacingOccurrences(of: "}", with: "")
                    if (j != "user_id"){
                        self.userID = j
                        self.delegate?.onGetUserIDSucces(userID: self.userID)
                        
                        let storyboard = UIStoryboard(name: "AdminMain", bundle: Bundle.main)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
                
              semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
    }
    override func viewDidLoad() {
        presenter = signUpGetUserIDPresenter(delegate: self)
        pwFIll.delegate = self
        emailFill.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension signUpGetUserIDViewController: signUpGetUserIDViewProtocol {
    func onBindGetUserIDResult(SignUpResult: LoginResult) {
        
    }
}

extension signUpGetUserIDViewController {
}
