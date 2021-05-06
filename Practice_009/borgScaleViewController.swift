//
//  borgScaleViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/23.
//

import Foundation
import UIKit

class borgScaleViewController: BaseViewController {
    var borgAns: Int = 0
    var stepSize: Double = 0.0
    let oriColor = UIColor(red: 181/255, green: 237/255, blue: 235, alpha: 1)
    let changeColor = UIColor(red: 104/255, green: 200/255, blue: 206, alpha: 1)
    let today = Date()
    let dateFormatter = DateFormatter()
    var str: String = ""
    var sent: [String: Int] = [:]
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var tenButton: UIButton!
    @IBOutlet weak var summitButton: UIButton!
    @IBAction func selZero(_ sender: Any) {
        borgAns = 0
        zeroButton.backgroundColor = changeColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selOne(_ sender: Any) {
        borgAns = 1
        oneButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selTwo(_ sender: Any) {
        borgAns = 2
        twoButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selThree(_ sender: Any) {
        borgAns = 3
        threeButton.backgroundColor = changeColor
        
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selFour(_ sender: Any) {
        borgAns = 4
        fourButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selFive(_ sender: Any) {
        borgAns = 5
        fiveButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
        
    }
    @IBAction func selSix(_ sender: Any) {
        borgAns = 6
        sixButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
        
    }
    @IBAction func selSeven(_ sender: Any) {
        borgAns = 7
        sevenButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    
    @IBAction func selEight(_ sender: Any) {
        borgAns = 8
        eightButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    
    @IBAction func selNine(_ sender: Any) {
        borgAns = 9
        nineButton.backgroundColor = changeColor
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        tenButton.backgroundColor = oriColor
    }
    @IBAction func selTen(_ sender: Any) {
        borgAns = 10
        tenButton.backgroundColor = changeColor
        
        zeroButton.backgroundColor = oriColor
        oneButton.backgroundColor = oriColor
        twoButton.backgroundColor = oriColor
        threeButton.backgroundColor = oriColor
        fourButton.backgroundColor = oriColor
        fiveButton.backgroundColor = oriColor
        sixButton.backgroundColor = oriColor
        sevenButton.backgroundColor = oriColor
        eightButton.backgroundColor = oriColor
        nineButton.backgroundColor = oriColor
    }
    @IBAction func summit(_ sender: Any) {
        //send to ViewController.swift
        let notificationName = Notification.Name("sendbefBorg")
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        str = dateFormatter.string(from: today)
        sent = [str : borgAns]
        Foundation.NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":sent])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? smartCoachListViewController
        vc?.stepSize = stepSize
        vc?.startTime = str
    }
    override func viewDidLoad() {
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        str = dateFormatter.string(from: today)
    }
}
