//
//  signUpGetUserIDViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/23.
//

import Foundation
import UIKit

class signUpGetUserIDViewController: UIViewController, UITextFieldDelegate, signUpGetUserIDViewProtocol { ///
    @IBOutlet weak var pwFIll: UITextField!
    @IBOutlet weak var emailFill: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    private var presenter: signUpGetUserIDPresenterProtocol?
    @IBAction func send(_ sender: Any) {
        //TODO 連接台大醫神後端API
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
