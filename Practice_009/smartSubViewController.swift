//
//  smartSubViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/23.
//

import Foundation
import UIKit


class smartSubViewController:BaseViewController{
    var stepSize:Double = 0.0
    var beforeBorg:Int = 0
    var afterBorg:Int = 0
    @IBOutlet weak var introLabel: UILabel!
    override func viewDidLoad() {
        introLabel.text = "您好！\n我是智慧教練，等下的訓練\n 會透過節奏帶領你走路的速度，\n請開啟音效，希望能帶給你一段愉快的訓練，\n準備好了就開始吧！"
    }
    @IBAction func startTest(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? borgScaleViewController
        vc?.stepSize = stepSize
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
}
