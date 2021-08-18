//
//  quesViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/3.
//

import Foundation
import UIKit

class quesViewController: BaseViewController{
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var compContentLabel: UILabel!
    var userDefaults: UserDefaults!
    var catAry:[String] = []
    var eq5Ary:[String] = []
    var mrcAry:[Int] = []
    var totalAry:[Int] = []
    let today = Date()
    let dateFormatter = DateFormatter()
    let notificationName = Notification.Name("sendQuesArray")
    let userId = UserDefaultUtil.shared.adminUserID
    private var presenter: quesPresenterProtocol?
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        _ = segue.source as? CATViewController
        _ = segue.source as? eq5dViweController
        _ = segue.source as? mMRCViewController
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let str: String = dateFormatter.string(from: today)
        if (catAry.count == 9) && (eq5Ary.count == 5) && (mrcAry.count == 1){
            completeLabel.text = "今日已完成：(3/3)"
            compContentLabel.text = ""
        }else if(catAry.count != 9) && (eq5Ary.count == 5) && (mrcAry.count == 1){
            completeLabel.text = "今日已完成：(2/3)"
            compContentLabel.text = "尚未完成CAT問卷"
            compContentLabel.font = compContentLabel.font.withSize(25)
        }else if(catAry.count == 9) && (eq5Ary.count != 5) && (mrcAry.count == 1){
            completeLabel.text = "今日已完成：(2/3)"
            compContentLabel.text = "尚未完成生活質量問卷"
            compContentLabel.font = compContentLabel.font.withSize(25)
        }else if(catAry.count == 9) && (eq5Ary.count == 5) && (mrcAry.count != 1){
            completeLabel.text = "今日已完成：(2/3)"
            compContentLabel.text = "尚未完成mMRC問卷"
            compContentLabel.font = compContentLabel.font.withSize(25)
        }else if(catAry.count != 9) && (eq5Ary.count != 5) && (mrcAry.count != 1){
            completeLabel.text = "今日已完成：(0/3)"
        }else{
            completeLabel.text = "今日已完成：(1/3)"
            if (catAry.count == 9){
                compContentLabel.text = "已完成CAT問卷"
                compContentLabel.font = compContentLabel.font.withSize(25)
            }else if(eq5Ary.count == 5){
                compContentLabel.text = "已完成生活質量問卷"
                compContentLabel.font = compContentLabel.font.withSize(25)
            }else if(mrcAry.count == 1){
                compContentLabel.text = "已完成mMRC問卷"
                compContentLabel.font = compContentLabel.font.withSize(25)
            }
        }
        if (completeLabel.text == "今日已完成：(3/3)")&&(totalAry.count == 0){
            for cont in mrcAry{
                totalAry.append(cont) // 0
            }
            for cont in eq5Ary{
                let cont = Int(cont)!
                totalAry.append(cont) //1-5
            }
            for cont in catAry{
                let cont = Int(cont)!
                totalAry.append(cont) //6-
            }
            let sent: [String: [Int]] = [str : totalAry]
            Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":sent])
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let today_DATE: String = dateFormatter.string(from: today)
            userDefaults.set(totalAry.count, forKey: today_DATE+"totalAry")
            userDefaults.synchronize()
            
            print(UserDefaults.standard.dictionaryRepresentation())

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let str: String = dateFormatter.string(from: today)
            presenter?.postQues(userId: userId!, cat1: totalAry[6], cat2: totalAry[7], cat3: totalAry[8], cat4: totalAry[9], cat5: totalAry[10], cat6: totalAry[11], cat7: totalAry[12], cat8: totalAry[13], catsum: totalAry[14], eq1: totalAry[1], eq2: totalAry[2], eq3: totalAry[3], eq4: totalAry[4], eq5: totalAry[5], mmrc: totalAry[0], timestamp: str)
            
        }
    }
    @objc func alertForUnfinish(){
        if (totalAry.count == 0){
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "退出",
            message: "今天問卷尚未完成",
            preferredStyle: .alert)

        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
          title: "取消",
            style: .cancel,
          handler: nil)
        alertController.addAction(cancelAction)

        // 建立[刪除]按鈕
        let okAction = UIAlertAction(
          title: "返回",
            style: .destructive) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)

        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today: String = dateFormatter.string(from: today)
        let todayIndex = UserDefaults.standard.integer(forKey: today+"totalAry")
        if (todayIndex == 15){
            completeLabel.text = "今日已完成：(3/3)"
            let alertController = UIAlertController(title: nil, message: "今天問卷已經填寫完成囉! ", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "好", style: .default){(action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(confirmAction)
            present(alertController, animated: true)
        }
        
    }
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        userDefaults = UserDefaults.standard
        self.navigationController?.navigationBar.isHidden = false
        presenter = quesPresenter(delegate: self)
        let leftButton = UIBarButtonItem(
            title:" < ",
            style:.plain,
            target:self,
            action:#selector(alertForUnfinish))
        // 加到導覽列中
        self.navigationItem.leftBarButtonItem = leftButton
        self.setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
        self.setCustomRightBarButtonItems(barButtonItems: [leftButton])
    }
}
extension quesViewController: quesViewProtocol {
    func onBindQuesResult(PostQues: PostQues) {
        self.navigationController?.popViewController(animated: true)
    }
}
