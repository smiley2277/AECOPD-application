//
//  offlinePredictViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/8.
//

import Foundation
import UIKit
import CoreML

class offlinePredictViewController: UIViewController {
    var questionAry:[Int] = []
    @IBAction func predict(_ sender: Any) {
        let model = COPDRfcOffline()
        guard let output = try? model.prediction(Mmrc:Double(questionAry[0]), _1_move:Double(questionAry[1]), _2_selfcare:Double(questionAry[2]),_3_activity:Double(questionAry[3]), _4_uncomfor:Double(questionAry[4]),
                                                 _5_depress:Double(questionAry[5]),CAT_1:Double(questionAry[6]) ,CAT_2:Double(questionAry[7]), CAT_3:Double(questionAry[8]), CAT_4:Double(questionAry[9]), CAT_5:Double(questionAry[10]), CAT_6:Double(questionAry[11]), CAT_7:Double(questionAry[12]),CAT_8:Double(questionAry[13]), CAT_total:Double(questionAry[14])) else {
            return
        }
        let value = output.value
        print(value, questionAry)
        if (questionAry[0]>0){
            let scAlert = UIAlertController(title: "提醒", message: "請開啟智慧教練訓練課程", preferredStyle: .alert)
            scAlert.addAction(UIAlertAction(title: "確定", style: .cancel))
            self.present(scAlert, animated: true)
        }
        
        
    }
    override func viewDidLoad() {
        
    }
    
    
}
