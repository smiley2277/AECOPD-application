//
//  quesViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/3.
//

import Foundation
import UIKit

class quesViewController: UIViewController{
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var compContentLabel: UILabel!
    var catAry:[String] = []
    var eq5Ary:[String] = []
    var mrcAry:[Int] = []
    var totalAry:[Int] = []
    let today = Date()
    let dateFormatter = DateFormatter()
    let notificationName = Notification.Name("sendQuesArray")
//    let notiName = Notification.Name("sendQuesArraytoPredict")
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        _ = segue.source as? CATViewController
        _ = segue.source as? eq5dViweController
        _ = segue.source as? mMRCViewController
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
                totalAry.append(cont)
            }
            for cont in eq5Ary{
                let cont = Int(cont)!
                totalAry.append(cont)
            }
            for cont in catAry{
                let cont = Int(cont)!
                totalAry.append(cont)
            }
            
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let str: String = dateFormatter.string(from: today)
            let sent: [String: [Int]] = [str : totalAry]
            Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":sent])
            
        }
//        print(mrcAry.count, eq5Ary.count, catAry.count)
//        print(totalAry.count)
//        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":totalAry])
//        Foundation.NotificationCenter.default.post(name: notiName, object: nil, userInfo: ["PASS2":totalAry])
    }
    
    
    

    override func viewDidLoad() {
        
    }
    
    
}
